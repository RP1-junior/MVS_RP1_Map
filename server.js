const { MVSF         } = require ('@metaversalcorp/mvsf');
const { InitSQL      } = require ('./utils.js');
const Settings      = require ('./settings.json');
const fs            = require ('fs');
const path          = require ('path');
const mysql         = require ('mysql2/promise');
const zlib          = require ('zlib');

const { MVSQL_MYSQL  } = require ('@metaversalcorp/mvsql_mysql');

/*******************************************************************************************************************************
**                                                     Main                                                                   **
*******************************************************************************************************************************/
class MVSF_Map
{
   #pServer;
   #pSQL;

   constructor ()
   {
      this.ReadFromEnv (Settings.SQL.config, [ "host", "port", "user", "password", "database" ]);
      this.ProcessFabricConfig ();

      switch (Settings.SQL.type)
      {
      case 'MYSQL':
         this.#pSQL = new MVSQL_MYSQL (Settings.SQL.config, this.onSQLReady.bind (this)); 
         break;

      default:
         console.log ('No Database was configured for this service.');
         break;
      }
   }

   #GetToken (sToken) 
   {
      const match = sToken.match (/<([^>]+)>/);
      return match ? match[1] : null;
   }

   ReadFromEnv (Config, aFields)
   {
      let sValue;
      
      for (let i=0; i < aFields.length; i++)
      {
         if ((sValue = this.#GetToken (Config[aFields[i]])) != null)
            Config[aFields[i]] = process.env[sValue];
      }
   }

   ProcessFabricConfig ()
   {
      const sFabricPath = path.join (__dirname, 'web', 'public', 'config', 'fabric.msf.json');
      
      try
      {
         let sContent = fs.readFileSync (sFabricPath, 'utf8');
         
         // Replace all occurrences of <RAILWAY_PUBLIC_DOMAIN> with the actual environment variable
         const sRailwayDomain = process.env.RAILWAY_PUBLIC_DOMAIN || '';
         sContent = sContent.replace (/<RAILWAY_PUBLIC_DOMAIN>/g, sRailwayDomain);
         
         fs.writeFileSync (sFabricPath, sContent, 'utf8');
      }
      catch (err)
      {
         console.log ('Error processing fabric.msf.json: ', err);
      }
   }

   async InitializeDatabase (pMVSQL)
   {
      const sDatabaseName = 'MVD_RP1_Map';
      const sSQLFile = path.join (__dirname, 'MVD_RP1_Map.sql');
      const sSQLGzFile = path.join (__dirname, 'MVD_RP1_Map.sql.gz');

      try
      {
         // Create a connection without specifying a database, with multipleStatements enabled
         const pConfig = { ...Settings.SQL.config };
         delete pConfig.database; // Remove database from config to connect without it
         pConfig.multipleStatements = true; // Enable multiple statements

         const pConnection = await mysql.createConnection (pConfig);

         // Check if database exists
         const [aRows] = await pConnection.execute (
            `SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ?`,
            [sDatabaseName]
         );

         if (aRows.length === 0)
         {
            console.log (`Database '${sDatabaseName}' does not exist. Creating and importing...`);

            // Determine which SQL file to use
            let sSQLContent = null;
            if (fs.existsSync (sSQLFile))
            {
               sSQLContent = fs.readFileSync (sSQLFile, 'utf8');
            }
            else if (fs.existsSync (sSQLGzFile))
            {
               const aBuffer = fs.readFileSync (sSQLGzFile);
               sSQLContent = zlib.gunzipSync (aBuffer).toString ('utf8');
            }
            else
            {
               throw new Error (`Neither ${sSQLFile} nor ${sSQLGzFile} found`);
            }

            // Modify CREATE DATABASE to use IF NOT EXISTS to avoid errors
            sSQLContent = sSQLContent.replace (
               /CREATE DATABASE\s+MVD_RP1_Map/gi,
               'CREATE DATABASE IF NOT EXISTS MVD_RP1_Map'
            );

            // Execute the entire SQL file
            try
            {
               await pConnection.query (sSQLContent);
               console.log (`Database '${sDatabaseName}' created and imported successfully.`);
            }
            catch (err)
            {
               // If database was created between check and execution, that's okay
               if (err.code === 'ER_DB_CREATE_EXISTS' || err.message.includes ('already exists'))
               {
                  console.log (`Database '${sDatabaseName}' was created by another process. Continuing...`);
               }
               else
               {
                  console.error ('Error executing SQL file:', err.message);
                  throw err;
               }
            }
         }
         else
         {
            console.log (`Database '${sDatabaseName}' already exists. Skipping initialization.`);
         }

         await pConnection.end ();
      }
      catch (err)
      {
         console.error ('Error initializing database:', err);
         throw err;
      }
   }

   async onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         try
         {
            // Initialize database if it doesn't exist
            await this.InitializeDatabase (pMVSQL);

            this.ReadFromEnv (Settings.MVSF, [ "nPort" ]);

            this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, null, 'application/json');
            this.#pServer.LoadHtmlSite (__dirname, [ './web/admin', './web/public']);
            this.#pServer.Run ();

            console.log ('SQL Server READY');
            InitSQL (pMVSQL, this.#pServer, Settings.Info);
         }
         catch (initErr)
         {
            console.error ('Error during database initialization:', initErr);
            console.log ('SQL Server Connect Error: ', initErr);
         }
      }
      else
      {
         console.log ('SQL Server Connect Error: ', err);
      }
   }
}

const g_pServer = new MVSF_Map ();

const { MVSF         } = require ('@metaversalcorp/mvsf');
const { InitSQL      } = require ('./utils.js');
const Settings      = require ('./settings.json');
const fs            = require ('fs');
const path          = require ('path');
const zlib          = require ('zlib');
const mysql         = require ('mysql2/promise');

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
         // Ensure database exists before establishing connection
         this.InitializeDatabase ().then (() => {
            this.#pSQL = new MVSQL_MYSQL (Settings.SQL.config, this.onSQLReady.bind (this)); 
         }).catch ((err) => {
            console.log ('Error initializing database: ', err);
            // Try to connect anyway - database might exist
            this.#pSQL = new MVSQL_MYSQL (Settings.SQL.config, this.onSQLReady.bind (this)); 
         });
         break;

      default:
         console.log ('No Database was configured for this service.');
         break;
      }
   }

   async InitializeDatabase ()
   {
      const sDatabaseName = Settings.SQL.config.database || 'MVD_RP1_Map';
      await this.EnsureDatabaseExists (Settings.SQL.config, sDatabaseName);
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

   async EnsureDatabaseExists (pSQLConfig, sDatabaseName)
   {
      try
      {
         // Create a connection without specifying the database
         const tempConfig = {
            host: pSQLConfig.host,
            port: pSQLConfig.port,
            user: pSQLConfig.user,
            password: pSQLConfig.password,
            multipleStatements: true
         };

         const connection = await mysql.createConnection (tempConfig);

         try
         {
            // Check if database exists
            const [rows] = await connection.query (
               `SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ?`,
               [sDatabaseName]
            );

            if (rows.length === 0)
            {
               console.log (`Database '${sDatabaseName}' does not exist. Creating and importing...`);
               
               // Create the database
               await connection.query (`CREATE DATABASE IF NOT EXISTS \`${sDatabaseName}\``);
               console.log (`Database '${sDatabaseName}' created.`);

               // Use the database
               await connection.query (`USE \`${sDatabaseName}\``);

               // Read and decompress the SQL file
               const sqlFilePath = path.join (__dirname, 'MVD_RP1_Map.sql.gz');
               
               if (!fs.existsSync (sqlFilePath))
               {
                  console.log (`Warning: SQL file '${sqlFilePath}' not found. Database created but not imported.`);
                  await connection.end ();
                  return;
               }

               const compressedData = fs.readFileSync (sqlFilePath);
               const sqlData = zlib.gunzipSync (compressedData).toString ('utf8');

               console.log (`Importing SQL file into database '${sDatabaseName}'...`);

               try
               {
                  // Try to execute the entire SQL file at once (MySQL supports multiple statements)
                  await connection.query (sqlData);
                  console.log (`Database '${sDatabaseName}' imported successfully.`);
               }
               catch (err)
               {
                  // If that fails, try splitting by semicolon and executing statement by statement
                  console.log (`Bulk import failed, trying statement-by-statement import...`);
                  
                  // Remove MySQL-specific comments and split by semicolon
                  let cleanedSQL = sqlData
                     .replace (/\/\*[\s\S]*?\*\//g, '') // Remove /* ... */ comments
                     .replace (/--.*$/gm, '') // Remove -- comments
                     .replace (/^#.*$/gm, ''); // Remove # comments

                  const statements = cleanedSQL
                     .split (';')
                     .map (stmt => stmt.trim ())
                     .filter (stmt => stmt.length > 0);

                  let successCount = 0;
                  let errorCount = 0;

                  for (const statement of statements)
                  {
                     try
                     {
                        await connection.query (statement);
                        successCount++;
                     }
                     catch (stmtErr)
                     {
                        // Some statements might fail (like DROP IF EXISTS on non-existent objects)
                        // Log but continue
                        if (!stmtErr.message.includes ('Unknown table') && 
                            !stmtErr.message.includes ('doesn\'t exist') &&
                            !stmtErr.message.includes ('Unknown database') &&
                            !stmtErr.message.includes ('already exists'))
                        {
                           console.log (`Warning: SQL statement failed: ${stmtErr.message.substring (0, 100)}`);
                           errorCount++;
                        }
                        else
                        {
                           successCount++; // Count as success if it's an expected error
                        }
                     }
                  }

                  console.log (`Database '${sDatabaseName}' import completed. ${successCount} statements succeeded, ${errorCount} errors.`);
               }
            }
            else
            {
               console.log (`Database '${sDatabaseName}' already exists.`);
            }
         }
         finally
         {
            await connection.end ();
         }
      }
      catch (err)
      {
         console.log (`Error ensuring database exists: ${err.message}`);
         throw err;
      }
   }

   onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         this.ReadFromEnv (Settings.MVSF, [ "nPort" ]);

         this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, null, 'application/json');
         this.#pServer.LoadHtmlSite (__dirname, [ './web/admin', './web/public']);
         this.#pServer.Run ();

         console.log ('SQL Server READY');
         InitSQL (pMVSQL, this.#pServer, Settings.Info);
      }
      else
      {
         console.log ('SQL Server Connect Error: ', err);
      }
   }
}

const g_pServer = new MVSF_Map ();

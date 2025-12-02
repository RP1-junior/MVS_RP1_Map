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
         
         // Replace all occurrences of <PUBLIC_DOMAIN> with the actual environment variable
         // Check for PUBLIC_DOMAIN first, fallback to RAILWAY_PUBLIC_DOMAIN for Railway compatibility
         const sPublicDomain = process.env.PUBLIC_DOMAIN || process.env.RAILWAY_PUBLIC_DOMAIN || '';
         sContent = sContent.replace (/<PUBLIC_DOMAIN>/g, sPublicDomain);
         
         fs.writeFileSync (sFabricPath, sContent, 'utf8');
      }
      catch (err)
      {
         console.log ('Error processing fabric.msf.json: ', err);
      }
   }

   #ParseSQLWithDelimiters (sSQLContent)
   {
      const aStatements = [];
      let sCurrentDelimiter = ';';
      const aLines = sSQLContent.split (/\r?\n/);
      let sCurrentStatement = '';

      for (let i = 0; i < aLines.length; i++)
      {
         const sLine = aLines[i];
         const sTrimmedLine = sLine.trim ();

         // Check for DELIMITER command (must be at start of line, case-insensitive)
         const nDelimiterMatch = sTrimmedLine.match (/^DELIMITER\s+(.+)$/i);
         
         if (nDelimiterMatch)
         {
            // If we have accumulated a statement, save it before changing delimiter
            if (sCurrentStatement.trim ().length > 0)
            {
               const sStatement = sCurrentStatement.trim ();
               if (!sStatement.match (/^--/))
               {
                  aStatements.push (sStatement);
               }
               sCurrentStatement = '';
            }

            // Update delimiter (remove quotes if present)
            sCurrentDelimiter = nDelimiterMatch[1].trim ().replace (/^['"]|['"]$/g, '');
            // Skip the DELIMITER line itself
            continue;
         }

         // Add line to current statement
         if (sCurrentStatement.length > 0)
         {
            sCurrentStatement += '\n' + sLine;
         }
         else
         {
            sCurrentStatement = sLine;
         }

         // Check if current statement ends with the delimiter
         // We need to check if the delimiter appears at the end (possibly with whitespace)
         const nDelimiterIndex = sCurrentStatement.lastIndexOf (sCurrentDelimiter);
         if (nDelimiterIndex !== -1)
         {
            // Check if delimiter is at the end (allowing for trailing whitespace)
            const sAfterDelimiter = sCurrentStatement.substring (nDelimiterIndex + sCurrentDelimiter.length).trim ();
            
            // If there's only whitespace or newlines after the delimiter, it's the end of the statement
            if (sAfterDelimiter.length === 0 || /^[\r\n\s]*$/.test (sAfterDelimiter))
            {
               // Extract the statement (without the delimiter)
               const sStatement = sCurrentStatement.substring (0, nDelimiterIndex).trim ();
               
               if (sStatement.length > 0 && !sStatement.match (/^--/))
               {
                  aStatements.push (sStatement);
               }
               
               sCurrentStatement = '';
            }
         }
      }

      // Add any remaining statement
      if (sCurrentStatement.trim ().length > 0)
      {
         const sStatement = sCurrentStatement.trim ();
         if (!sStatement.match (/^--/))
         {
            aStatements.push (sStatement);
         }
      }

      return aStatements;
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

            // Parse SQL respecting DELIMITER statements
            const aStatements = this.#ParseSQLWithDelimiters (sSQLContent);

            console.log (`Parsed ${aStatements.length} SQL statements. Executing...`);

            // Execute each statement
            for (let i = 0; i < aStatements.length; i++)
            {
               const sStatement = aStatements[i];
               
               // Skip empty statements and comments
               if (!sStatement || sStatement.trim ().length === 0 || sStatement.trim ().match (/^--/))
                  continue;

               try
               {
                  await pConnection.query (sStatement);
                  
                  // Log progress for large imports
                  if ((i + 1) % 50 === 0)
                  {
                     console.log (`Executed ${i + 1}/${aStatements.length} statements...`);
                  }
               }
               catch (err)
               {
                  // Ignore errors for CREATE DATABASE if it already exists
                  if (err.code === 'ER_DB_CREATE_EXISTS' || err.message.includes ('already exists'))
                  {
                     // This is okay, continue
                  }
                  else
                  {
                     console.error (`Error executing statement ${i + 1}/${aStatements.length}:`, err.message);
                     console.error (`Statement preview:`, sStatement.substring (0, 200) + '...');
                     throw err;
                  }
               }
            }

            console.log (`Database '${sDatabaseName}' created and imported successfully.`);

            // Add initial RMPObject row with public URL (only when database is first created)
            // Ensure we're using the correct database
            await pConnection.query (`USE ${sDatabaseName}`);
            
            // Check for PUBLIC_DOMAIN first, fallback to RAILWAY_PUBLIC_DOMAIN for Railway compatibility
            const sPublicDomain = process.env.PUBLIC_DOMAIN || process.env.RAILWAY_PUBLIC_DOMAIN || '';
            const sSceneUrl = sPublicDomain ? `https://${sPublicDomain}/scenes/scene.glb` : 'https://MYAPPURL.COM/scenes/scene.glb';
            
            try
            {
               await pConnection.query (
                  `INSERT INTO RMPObject (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                  [70, 1, 73, null, 1, 32, 1, 0, 1, 0, 25, 0, '', sSceneUrl, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 500, 500, 250]
               );
               console.log ('Initial RMPObject row inserted successfully.');
            }
            catch (insertErr)
            {
               // Check if row already exists (duplicate key or other constraint)
               if (insertErr.code === 'ER_DUP_ENTRY' || insertErr.message.includes ('Duplicate entry'))
               {
                  console.log ('Initial RMPObject row already exists. Skipping insert.');
               }
               else
               {
                  console.error ('Error inserting initial RMPObject row:', insertErr);
                  // Don't throw - allow the database initialization to complete
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

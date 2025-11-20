const mysql = require ('mysql2/promise');
const fs = require ('fs').promises;
const path = require ('path');

/*******************************************************************************************************************************
**                                                   Database Initialization                                                   **
*******************************************************************************************************************************/

/**
 * Initializes the MVD_RP1_Map database by checking if it exists and creating/importing it if needed
 * @param {Object} config - MySQL configuration object (host, port, user, password)
 * @returns {Promise<boolean>} - Returns true if database was initialized successfully, false otherwise
 */
async function InitializeDatabase (config)
{
   const dbName = 'MVD_RP1_Map';
   let connection = null;

   try
   {
      // Create a connection without specifying a database
      const connectionConfig = {
         host:     config.host,
         port:     config.port,
         user:     config.user,
         password: config.password,
         multipleStatements: true
      };

      connection = await mysql.createConnection (connectionConfig);

      console.log ('Checking if database exists...');

      // Check if database exists
      const [databases] = await connection.query (
         `SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ?`,
         [dbName]
      );

      if (databases.length > 0)
      {
         console.log (`Database '${dbName}' already exists. Skipping initialization.`);
         await connection.end ();
         return true;
      }

      console.log (`Database '${dbName}' does not exist. Creating and importing...`);

      // Create the database
      await connection.query (`CREATE DATABASE IF NOT EXISTS \`${dbName}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`);
      console.log (`Database '${dbName}' created successfully.`);

      // Switch to the new database
      await connection.query (`USE \`${dbName}\``);

      // Read and execute the SQL file
      const sqlFilePath = path.join (__dirname, 'MVD_RP1_Map.sql');
      
      try
      {
         const sqlFileContent = await fs.readFile (sqlFilePath, 'utf8');
         console.log ('Importing SQL file...');
         
         // Execute the SQL file
         // mysql2 with multipleStatements: true handles DELIMITER statements correctly
         await connection.query (sqlFileContent);
      }
      catch (fileError)
      {
         throw new Error (`Failed to read or execute SQL file: ${fileError.message}`);
      }

      console.log (`Database '${dbName}' initialized successfully.`);
      await connection.end ();
      return true;
   }
   catch (error)
   {
      console.error ('Error initializing database:', error);
      if (connection)
      {
         try
         {
            await connection.end ();
         }
         catch (e)
         {
            // Ignore errors when closing connection
         }
      }
      return false;
   }
}

module.exports = { InitializeDatabase };


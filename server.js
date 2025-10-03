const { MVSF         } = require ('@metaversalcorp/mvsf');
const { InitSQL      } = require ('./utils.js');
const Settings      = require ('./settings.json');

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

   onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         this.ReadFromEnv (Settings.MVSF, [ "nPort" ]);

         this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, null, 'application/json');
         this.#pServer.LoadHtmlPath (__dirname, [ './web/admin', './web/public']);
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

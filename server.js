const { MVSF         } = require ('@metaversalcorp/mvsf');
// const { MV           } = require ('@metaversalcorp/mvmf');
const { InitSQL      } = require ('./utils.js');
const Settings      = require ('./settings.json');

// const { MVSQL_MSSQL  } = require ('@metaversalcorp/mvsql_mssql');
const { MVSQL_MYSQL  } = require ('@metaversalcorp/mvsql_mysql');

// require ('@metaversalcorp/mvrp_rds');

/*******************************************************************************************************************************
**                                                     Main                                                                   **
*******************************************************************************************************************************/
class MVSF_Map
{
   #pServer;
   #pRDS;
   #pSQL;
   // #pRequire;

   constructor ()
   {
      switch (Settings.SQL.type)
      {
      case 'MYSQL':
         Settings.SQL.config.host= process.env.MYSQLHOST;
         Settings.SQL.config.port= process.env.MYSQLPORT;
         Settings.SQL.config.user= process.env.MYSQLUSER;
         Settings.SQL.config.password= process.env.MYSQLPASSWORD;
         Settings.SQL.config.database= process.env.MYSQLDATABASE;
         this.#pSQL = new MVSQL_MYSQL (Settings.SQL.config, this.onSQLReady.bind (this)); break;
      default:
         console.log('No database was configured for this service and it is required.');
         break;
      }
   }

   onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         // this.#pRequire = MV.MVMF.Core.Require ('MVRP_RDS');

         this.#pRDS = null; //new MV.MVRP.RDS.CLIENT (Settings.RDS);
         // this.#pRDS.Attach (this);

Settings.MVSF.nPort = process.env.PORT || 3000;
         this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, this.#pRDS, 'application/json');
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

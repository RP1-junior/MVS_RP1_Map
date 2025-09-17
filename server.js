const { MVSF, CreateMVSQL } = require ('@metaversalcorp/mvsf');
const { InitSQL      } = require ('./utils.js');
const Settings = require ('./settings.json');

// const { MVSQL_MSSQL  } = require ('@metaversalcorp/mvsql_mssql');
const { MVSQL_MYSQL  } = require ('@metaversalcorp/mvsql_mysql');

/*******************************************************************************************************************************
**                                                     Main                                                                   **
*******************************************************************************************************************************/
class MVSF_Map
{
   #pServer;
   #pRDS;
   #pSQL;
   #pRequire;

   constructor ()
   {
      switch (SQLConfig.type) {
//         case 'MSSQL':
//            this.#pSQL = new MVSQL_MSSQL(Settings.SQL, this.onSQLReady.bind(this));
//            break;
         case 'MYSQL':
            this.#pSQL = new MVSQL_MYSQL(Settings.SQL, this.onSQLReady.bind(this));
            break;
         default:
            pMVSQL = null;
            break;
      }
   }

   onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         this.#pRequire = MV.MVMF.Core.Require ('MVRP_RDS');

         this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, null, 'application/json');
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

const { MVSF, CreateMVSQL } = require ('@metaversalcorp/mvsf');
const { InitSQL      } = require ('./utils.js');
const Settings = require ('./settings.json');

/*******************************************************************************************************************************
**                                                     Main                                                                   **
*******************************************************************************************************************************/
class MVSF_Map
{
   #pServer;
   #pRDS;
   #pRequire;

   constructor ()
   {
      const pSql = CreateMVSQL (Settings.SQL, this.onSQLReady.bind (this));
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

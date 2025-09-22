const fs = require ('node:fs');

var g_pMVSQL  = null;
var g_pServer = null;
var g_pInfo   = null;

var g_nTimeout = 0;


/*******************************************************************************************************************************
**                                                   Imported Functions                                                       **
*******************************************************************************************************************************/

function MemResult (pResult, result)
{
   pResult.nResult = result.output.nResult;

   if (pResult.nResult == 0)
   {
      pResult.Parent = JSON.parse (result.recordsets[0][0].Object);
      pResult.aChild = [];

      for (let i=1; i < result.recordsets.length; i++)
      {
         pResult.aChild[i-1] = [];
         for (let j=0; j < result.recordsets[i].length; j++)
         {
            pResult.aChild[i-1].push (JSON.parse (result.recordsets[i][j].Object));
         }
      }
   }
   else RawResult (pResult, result);
}

function RawResult (pResult, result)
{
   pResult.nResult = result.output.nResult;
   pResult.aResultSet = result.recordsets;
}

/*******************************************************************************************************************************
**                                                   Exported Functions                                                       **
*******************************************************************************************************************************/

function RunQuery (Session, pData, fnRSP, fn, pSQLData)
{
   let pResult = { nResult: -1, aResultSet: [] };

   const Query = g_pMVSQL.Compose (pSQLData.sProc, pData, pSQLData.aData, Session.sIPAddress);

   if (Query)
   {
      g_pMVSQL.Exec (Query).then
      (
         (result) =>
         {
            if (result != null)
            {
               if (pSQLData.Param == 0)
                  MemResult (pResult, result);
               else
                  RawResult (pResult, result);
            }

            fnRSP (fn, pResult);
         }
      );
   }
   else fnRSP (fn, pResult);
}

function RunQuery2Ex (Session, pData, fnRSP, fn, bRecover, pSQLData)
{
   let pResult = { nResult: -1, aResultSet: [] };

   if (true) //Session.bRP1 && (pSQLData.Param || Session.bGuest == 0))
   {
      const Query = g_pMVSQL.Compose (pSQLData.sProc, pData, pSQLData.aData, Session.sIPAddress, (Session.twRPersonaIx ? Session.twRPersonaIx : 0), 2);

      if (Query)
      {
         g_pMVSQL.Exec (Query).then
         (
            (result) =>
            {
               if (result != null)
               {
                  // TODO: Only Join the socket and send recover IF we are not subscribed
                  if (bRecover && result.output.nResult == 0)
                  {
                     pObjectHead = JSON.parse (result.recordsets[0][0].Object).ObjectHead;

                     let sChannelName = pObjectHead.wClass_Object + '-' + pObjectHead.twObjectIx;

                     Session.socket.join (sChannelName);
                     Session.socket.emit ('recover', 
                        {
                           nResult:    result.output.nResult, 
                           aResultSet: result.recordsets,
                        }
                     );
                  }
                  else
                  {
if (pSQLData.Param == 0)
   MemResult (pResult, result);
else
   RawResult (pResult, result);
//                     pResult.aResultSet = result.recordsets;
                     
//                     EventFetch ();
                  } 

                  pResult.nResult = result.output.nResult;
               }

               fnRSP (fn, pResult);
            }
         );
      }
      else fnRSP (fn, pResult);
   }
   else fnRSP (fn, pResult);
}

function RunQuery2 (Session, pData, fnRSP, fn, pSQLData)
{
   RunQuery2Ex (Session, pData, fnRSP, fn, false, pSQLData);
}

/*******************************************************************************************************************************
**                                                     Initialization                                                         **
*******************************************************************************************************************************/

function EventQueue (pServer)
{
   g_nTimeout = 0;

   let Query = g_pMVSQL.ComposeETL ('etl_Events');

   g_pMVSQL.Exec (Query).then
   (
      (result) =>
      {
         if (result != null && result.output.nResult == 0 && result.recordsets.length == 2)
         {
            let aRow = result.recordsets[0];

            for (let i=0; i < aRow.length; i++)
            {
               pObject = JSON.parse (aRow[i].Object);
   
               let sChannelName = 'GLOBALREFRESH'; //pObject.pControl.wClass_Object + '-' + pObject.pControl.twObjectIx;
   
               g_pServer.io.in (sChannelName).emit ('refresh', pObject);
            }

            if (result.recordsets[1][0].nCount > 0)
            {
               setTimeout (EventQueue, 0);
            }
         } 
      }
   );
}

function EventFetch ()
{
   if (g_nTimeout == 0)
   {
      g_nTimeout = setTimeout (EventQueue, 100);
   }
}

function Test (fn, Result)
{
   console.log ('Result: ', Result);
}

function InitSQL (pSQL, pServer, pInfo)
{
   g_pMVSQL  = pSQL;
   g_pServer = pServer;
   g_pInfo   = pInfo;

//RunQuery2 ({ sIPAddress: '10.10.1.100' }, { twRMRootIx: 1 }, Test, null, { sProc: 'get_RMRoot_Update', aData: [ 'twRMRootIx' ], Param: 0 });
   setInterval (EventFetch, 1000);
}

function GetInfo (sEntry, twObjectIx, fnRSP, fn)
{
   if (g_pInfo)
   {
      let sObjectIx = twObjectIx.toString ();

      for (let i=sObjectIx.length; i < 10; i++)
         sObjectIx = '0' + sObjectIx;

      let sFileName = g_pInfo[sEntry] + sEntry + '\\' + sObjectIx.slice (0, 1) + '\\' + sObjectIx.slice (1, 4) + '\\' + sObjectIx.slice (4, 7) + '\\' + sObjectIx + '.json';

      fs.readFile (sFileName, 'utf8', (err, data) => {
         if (err)
         {
            fnRSP (fn, { nResult: -1 });
         }
         else
         {
            fnRSP (fn, { nResult: 0, sData: data });
         }
      });
   }
   else fnRSP (fn, { nResult: -2 });
}

module.exports =
{
   RunQuery,
   RunQuery2,
   RunQuery2Ex,
   InitSQL,
   GetInfo
}

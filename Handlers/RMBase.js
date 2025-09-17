const { MVHANDLER } = require ('@metaversalcorp/mvsf');
const { RunQuery2, RunQuery2Ex  } = require ('../utils.js');

/*******************************************************************************************************************************
**                                                     Internal                                                               **
*******************************************************************************************************************************/

const g_awClass_Data = 
{
    70:  {                 // SBM_CLASS_RMROOT
            sParam: '',                    
            sProc:  'get_RMRoot_Update'
         },
    71:  {                 // SBM_CLASS_RMCObject
            sParam: 'twRMCObjectIx', 
            sProc:  'get_RMCObject_Update'
         },
    72:  {                 // SBM_CLASS_RMTObject
            sParam: 'twRMTObjectIx',
            sProc:  'get_RMTObject_Update'
         },
    73:  {                 // SBM_CLASS_RMPObject
            sParam: 'twRMPObjectIx',
            sProc:  'get_RMPObject_Update'
         },
};

class HndlrRMBase extends MVHANDLER
{
   constructor ()
   {
      super 
      (
         null, 
         null,
         null,
         {
            "subscribe": {
               sCB: "Subscribe"
            },
            "unsubscribe": {
               sCB: "Unsubscribe"
            },
         },
         RunQuery2
      );
   }

   Subscribe (pConn, Session, pData, fnRSP, fn)
   {
      let pParam = {};
      let aParam;

      if (pData.wClass_Object && g_awClass_Data[pData.wClass_Object])
      {
         if (g_awClass_Data[pData.wClass_Object].sParam != '')
         {
            aParam = [ g_awClass_Data[pData.wClass_Object].sParam ];
            pParam[g_awClass_Data[pData.wClass_Object].sParam] = pData.twObjectIx;
         }
         else aParam = [];

         RunQuery2Ex 
         (
            Session, 
            pParam, 
            fnRSP, 
            fn, 
            true, 
            {
               sProc: g_awClass_Data[pData.wClass_Object].sProc,
               aData: aParam,
               Param: true
            }
         );
      }
   }

   Unsubscribe (pConn, Session, pData, fnRSP, fn)
   {
      if (Session.pSocket)
         Session.pSocket.leave (pData.wClass_Object + '-' + pData.twObjectIx);
   }

}

/*******************************************************************************************************************************
**                                                     Initialization                                                         **
*******************************************************************************************************************************/

module.exports = HndlrRMBase;

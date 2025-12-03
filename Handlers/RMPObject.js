const { MVHANDLER } = require ('@metaversalcorp/mvsf');
const { GetInfo, RunQuery, RunQuery2 } = require ('../utils.js');

class HndlrRMPObject extends MVHANDLER
{
   constructor ()
   {
      super 
      (
         'rmpobject', 
         {
            'update': {
               SqlData: {
                  sProc: 'get_RMPObject',
                  aData: [ 'twRMPObjectIx' ],
                  Param: 0
               }
            }
         },
         RunQuery,
         {
            'RMPObject:update': {
               SqlData: {
                  sProc: 'get_RMPObject_Update',
                  aData: [ 'twRMPObjectIx' ],
                  Param: 0
               }
            },
            "RMPObject:info": {
               sCB: "Info"
            },

            'RMPObject:bound': {
               SqlData: {
                  sProc: 'set_RMPObject_Bound',
                  aData: [ 'twRMPObjectIx',
                           'Bound_dX', 'Bound_dY', 'Bound_dZ' 
                  ],
                  Param: 1
               }
            },

            'RMPObject:name': {
               SqlData: {
                  sProc: 'set_RMPObject_Name',
                  aData: [ 'twRMPObjectIx', 'Name_wsRMPObjectId' ],
                  Param: 1
               }
            },

            'RMPObject:owner': {
               SqlData: {
                  sProc: 'set_RMPObject_Owner',
                  aData: [ 'twRMPObjectIx', 
                           'Owner_twRPersonaIx' 
                  ],
                  Param: 1
               }
            },

            'RMPObject:resource': {
               SqlData: {
                  sProc: 'set_RMPObject_Resource',
                  aData: [ 'twRMPObjectIx',
                           'Resource_qwResource', 'Resource_sName', 'Resource_sReference', 
                  ],
                  Param: 1
               }
            },

            'RMPObject:rmpobject_close': {
               SqlData: {
                  sProc: 'set_RMPObject_RMPObject_Close',
                  aData: [ 'twRMPObjectIx',
                           'twRMPObjectIx_Close', 'bDeleteAll' 
                  ],
                  Param: 1
               }
            },

            'RMPObject:rmpobject_open': {
               SqlData: {
                  sProc: 'set_RMPObject_RMPObject_Open',
                  aData: [ 'twRMPObjectIx',
                           'Name_wsRMPObjectId',
                           'Type_bType', 'Type_bSubtype', 'Type_bFiction', 'Type_bMovable',
                           'Owner_twRPersonaIx', 
                           'Resource_qwResource', 'Resource_sName', 'Resource_sReference', 
                           'Transform_Position_dX', 'Transform_Position_dY', 'Transform_Position_dZ', 'Transform_Rotation_dX', 'Transform_Rotation_dY', 'Transform_Rotation_dZ', 'Transform_Rotation_dW', 'Transform_Scale_dX', 'Transform_Scale_dY', 'Transform_Scale_dZ',      
                           'Bound_dX', 'Bound_dY', 'Bound_dZ'
                  ],
                  Param: 1
               }
            },

            'RMPObject:transform': {
               SqlData: {
                  sProc: 'set_RMPObject_Transform',
                  aData: [ 'twRMPObjectIx',
                           'Transform_Position_dX', 'Transform_Position_dY', 'Transform_Position_dZ', 'Transform_Rotation_dX', 'Transform_Rotation_dY', 'Transform_Rotation_dZ', 'Transform_Rotation_dW', 'Transform_Scale_dX', 'Transform_Scale_dY', 'Transform_Scale_dZ'
                  ],
                  Param: 1
               }
            },

            'RMPObject:type': {
               SqlData: {
                  sProc: 'set_RMPObject_Type',
                  aData: [ 'twRMPObjectIx',
                           'Type_bType', 'Type_bSubtype', 'Type_bFiction', 'Type_bMovable'
                  ],
                  Param: 1
               }
            }
         },
         RunQuery2
      );
   }
   
   Info (pConn, Session, pData, fnRSP, fn)
   {
      GetInfo (pData.sType, pData.twRMPObjectIx, fnRSP, fn);
   }
}

/*******************************************************************************************************************************
**                                                     Initialization                                                         **
*******************************************************************************************************************************/

module.exports = HndlrRMPObject;

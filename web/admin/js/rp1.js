class ExtractMap extends MV.MVMF.NOTIFICATION
{
   #m_pFabric;
   #m_pLnG;
   #m_MapRMXItem;
   #m_wClass_Object;
   #m_twObjectIx;

   #jPObject;
   #pRMXRoot;

   static eSTATE =
   {
      NOTREADY : 0,
      READY    : 1,
      REDIRECT : 2,
   };

   eSTATE = ExtractMap.eSTATE;
   constructor (jSelector, sURL, wClass_Object, twObjectIx, pLnGPrimary)
   {
      super ();

      this.jSelector = jSelector;

      this.#m_wClass_Object = (wClass_Object == 0) ? 71 : wClass_Object;
      this.#m_twObjectIx    = (twObjectIx == 0)  ? 1 : twObjectIx;

      this.xCollator = new Intl.Collator ();

      this.#m_MapRMXItem   = {};
      this.#pRMXRoot       = null;

      this.#jPObject = this.jSelector.find ('.jsPObject');
      this.#jPObject.on ('change', this.onClick_Scene.bind (this));

      this.#m_pFabric = new MV.MVRP.MSF (sURL, MV.MVRP.MSF.eMETHOD.GET);
      this.#m_pFabric.Attach (this);
   }

   destructor ()
   {
      if (this.#m_pLnG)
      {
         for (let sItem in this.#m_MapRMXItem)
         {
            let Item = this.#m_MapRMXItem[sItem];

            Item.pRMXObject.Detach (this);
            this.#m_pLnG.Model_Close (Item.pRMXObject);
         }

         this.#m_pFabric.Detach (this);
         this.#m_pFabric.destructor ();

         this.#m_pFabric = null;
         this.#m_pLnG = null;
      }
   }

   onInserted (pNotice)
   {
      if (this.ReadyState () == this.eSTATE.READY)
      {
         if (pNotice.pData.pChild != null)
         {
            if (pNotice.pData.pChild == 'RMCObject')
            {
            }
         }
      }
   }

   onUpdated (pNotice)
   {
      if (this.ReadyState () == this.eSTATE.READY)
      {
         if (pNotice.pData.pChild != null)
         {
            this.UpdateView ();
         }
      }
   }

   onChanged (pNotice)
   {
      this.onUpdated (pNotice);
   }

   onDeleting (pNotice)
   {
      if (this.ReadyState () == this.eSTATE.READY)
      {
         if (pNotice.pData.pChild != null)
         {
            if (pNotice.pData.pChild.sID == 'RMCObject')
            {
            }
         }
      }
   }

   EnumItem (pRMXObject, Param)
   {
      Param.push (pRMXObject);
   }

   EnumRoot (pRMXObject, Param)
   {
      Param[pRMXObject.twObjectIx] = pRMXObject;
   }

   FindInsertItem (Item, pRMXObject)
   {
      let Result = null;

      if (Item.twObjectIx == pRMXObject.twObjectIx || Item.twObjectIx == pRMXObject.twParentIx)
         Result = Item;
      else
      {
         for (let n=0; n < Item.aChildren.length && (Result = this.FindInsertItem (Item.aChildren[n], pRMXObject)) == null; n++);
      }

      return Result;
   }

   PObjectToJSON (pRMXObject, bRoot)
   {
      let Result = {
         twObjectIx:    pRMXObject.twObjectIx,
         sName:         pRMXObject.pResource.sName,
         pTransform:    {
            aPosition: [
               pRMXObject.pTransform.vPosition.dX,
               pRMXObject.pTransform.vPosition.dY,
               pRMXObject.pTransform.vPosition.dZ
            ],
            aRotation: [
               pRMXObject.pTransform.qRotation.dX,
               pRMXObject.pTransform.qRotation.dY,
               pRMXObject.pTransform.qRotation.dZ,
               pRMXObject.pTransform.qRotation.dW
            ],
            aScale: [
               pRMXObject.pTransform.vScale.dX,
               pRMXObject.pTransform.vScale.dY,
               pRMXObject.pTransform.vScale.dZ
            ],
         },
         aBound: [
            pRMXObject.pBound.dX,
            pRMXObject.pBound.dY,
            pRMXObject.pBound.dZ
         ],
         aChildren:     []
      };

      if (bRoot == false)
      {
         Result.pResource = {
            sReference:    pRMXObject.pResource.sReference
         };
      }

      return Result;
   }

   ParseTree (aEditor, pRMXObject)
   {
      let Node = this.PObjectToJSON (pRMXObject, (pRMXObject.wClass_Parent == 70));
      let apRMXObject = [];

      aEditor.push (Node);
      
      pRMXObject.Child_Enum ('RMPObject', this, this.EnumItem, apRMXObject);

      for (let n=0; n < apRMXObject.length; n++)
         this.ParseTree (Node.aChildren, apRMXObject[n]);
   }

   UpdateScene ()
   {
      let bDone = true;
      for (let sKey in this.#m_MapRMXItem)
      {
         if (this.#m_MapRMXItem[sKey].IsReady () == false)
            bDone = false;
      }

      if (bDone)
      {
         let aEditor = [];

         this.ParseTree (aEditor, this.#pRMXRoot);

         const sResult = generateSceneJSONEx (JSON.stringify (aEditor, null, 2));

         setJSONEditorText (sResult);
         parseJSONAndUpdateScene (sResult);
      }
   }

   onReadyState (pNotice)
   {
      if (pNotice.pCreator == this.#m_pFabric)
      {
         if (this.#m_pFabric.IsReady ())
         {
            this.Exec ();
            this.ReadyState (this.eSTATE.READY);
         }
      }
      else if (pNotice.pCreator.IsReady ())
      {
         let pObjectHead = pNotice.pCreator.pSource.pObjectHead;

         if (pObjectHead.wClass_Object == 73)
         {
            let aPObject = [];
            pNotice.pCreator.Child_Enum ('RMPObject', this, this.EnumItem, aPObject);

            for (let i=0; i < aPObject.length; i++)
            {
               if (this.#m_MapRMXItem['73' + '-' + aPObject[i].twObjectIx] == undefined)
               {
                  this.#m_MapRMXItem['73' + '-' + aPObject[i].twObjectIx] = aPObject[i];
                  aPObject[i].Attach (this);
               }
               else
               {
                  // Do Nothing as we have already fetched the data for this object
               }
            }

         }
         else if (pObjectHead.wClass_Object == 70)
         {
            let mpPObject = {};
            let bInsert = true;

            pNotice.pCreator.Child_Enum ('RMPObject', this, this.EnumRoot, mpPObject);

            for (let twObjectIx in mpPObject)
            {
               if (bInsert)
               {
                  this.#m_MapRMXItem['73' + '-' + twObjectIx] = mpPObject[twObjectIx];
                  this.#m_MapRMXItem['73' + '-' + twObjectIx].Attach (this);

                  this.#pRMXRoot = this.#m_MapRMXItem['73' + '-' + twObjectIx];

                  bInsert = false;
               }
               
               this.#jPObject.append('<option value="' + twObjectIx + '">Scene - ' + twObjectIx + '</option>');
            }
         }
         
         this.UpdateScene ();
      }
   }

   Exec ()
   {
      let sID;

      if (this.#m_pLnG == null)
      {
         this.#m_pLnG = this.#m_pFabric.GetLnG ("map");
         if (this.#m_wClass_Object == 70)
            sID = 'RMRoot';
         else if (this.#m_wClass_Object == 71)
            sID = 'RMCObject';
         else if (this.#m_wClass_Object == 72)
            sID = 'RMTObject';
         else if (this.#m_wClass_Object == 73)
            sID = 'RMPObject';

         this.#m_MapRMXItem[this.#m_wClass_Object + '-' + this.#m_twObjectIx] = this.#m_pLnG.Model_Open (sID, this.#m_twObjectIx);
         this.#m_MapRMXItem[this.#m_wClass_Object + '-' + this.#m_twObjectIx].Attach (this);
      }
   }

   onClick_Scene (e)
   {
      let jOption = this.#jPObject.find ("option:selected");
      let twObjectIx = jOption.val ();

      if (this.#m_MapRMXItem['73' + '-' + twObjectIx] == undefined)
      {
         this.#m_MapRMXItem['73' + '-' + twObjectIx] = this.#m_pLnG.Model_Open ('RMPObject', twObjectIx);
         this.#pRMXRoot = this.#m_MapRMXItem['73' + '-' + twObjectIx];
         this.#m_MapRMXItem['73' + '-' + twObjectIx].Attach (this);
      }
      else
      {
         this.#pRMXRoot = this.#m_MapRMXItem['73' + '-' + twObjectIx];
         this.UpdateScene ();
      } 
   }

   UpdateView ()
   {
   }

   RMCopy_Type (pJSON, pType)
   {
      let bResult = true;

      if (pJSON.pType)
      {
         pType.bType     = pJSON.pType.bType;   
         pType.bSubtype  = pJSON.pType.bSubtype;
         pType.bFiction  = pJSON.pType.bFiction;
         pType.bMovable  = pJSON.pType.bMovable;
      }
      else bResult = false;

      return bResult;
   }

   RMCopy_CName (pJSON, pName)
   {
      let bResult = true;

      if (pJSON.sName)
      {
         pName.wsRMPObjectId = pJSON.sName;
      }
      else bResult = false;

      return bResult;
   }

   RMCopy_Owner (pJSON, pOwner)
   {
      let bResult = true;

      if (pJSON.pOwner)
      {
         pOwner.twRPersonaIx = pJSON.pOwner.twRPersonaIx;
      }
      else bResult = false;

      return bResult;
   }

   RMCopy_Resource (pRMPObject, pJSON, pResource)
   {
      let bResult = true;

      if (pJSON.pResource)
      {
         pResource.qwResource      = pRMPObject.pResource.qwResource;
         pResource.sName           = pRMPObject.pResource.sName;
         pResource.sReference      = pJSON.pResource.sReference;
      }
      else bResult = false;

      return bResult;
   }

   RMCopy_Transform (pJSON, pTransform)
   {
      let bResult = true;

      if (pJSON.pTransform)
      {
         pTransform.vPosition.dX   = pJSON.pTransform.aPosition[0];
         pTransform.vPosition.dY   = pJSON.pTransform.aPosition[1];
         pTransform.vPosition.dZ   = pJSON.pTransform.aPosition[2];
                                 
         pTransform.qRotation.dX   = pJSON.pTransform.aRotation[0];
         pTransform.qRotation.dY   = pJSON.pTransform.aRotation[1];
         pTransform.qRotation.dZ   = pJSON.pTransform.aRotation[2];
         pTransform.qRotation.dW   = pJSON.pTransform.aRotation[3];
                                 
         pTransform.vScale.dX      = pJSON.pTransform.aScale[0];
         pTransform.vScale.dY      = pJSON.pTransform.aScale[1];
         pTransform.vScale.dZ      = pJSON.pTransform.aScale[2];
      }
      else bResult = false;

      return bResult;
   }

   RMCopy_Bound (pJSON, pBound)
   {
      let bResult = true;

      if (pJSON.pTransform)
      {
         pBound.dX    = pJSON.aBound[0];
         pBound.dY    = pJSON.aBound[1];
         pBound.dZ    = pJSON.aBound[2];
      }
      else bResult = false;

      return bResult;
   }

   onRSPGeneric (pIAction, Param)
   {
      if (pIAction.pResponse.GetResult () == 0)
      {
      }
      else console.log ('ERROR: ' + pIAction.pResponse.GetResult ());
   }

   RMPEditType (pRMPObject, pRMPObjectJSON)
   {
      let pIAction = pRMPObject.Request ('TYPE');
      let Payload = pIAction.pRequest;

      if (this.RMCopy_Type (pRMPObjectJSON, Payload.pType))
         pIAction.Send (this, this.onRSPGeneric.bind (This));
   }

   RMPEditResource (pRMPObject, pRMPObjectJSON)
   {
      let pIAction = pRMPObject.Request ('RESOURCE');
      let Payload = pIAction.pRequest;

      if (this.RMCopy_Resource (pRMPObject, pRMPObjectJSON, Payload.pResource))
         pIAction.Send (this, this.onRSPGeneric.bind (This));
   }

   RMPEditBound (pRMPObject, pRMPObjectJSON)
   {
      let pIAction = pRMPObject.Request ('BOUND');
      let Payload = pIAction.pRequest;

      if (this.RMCopy_Bound (pRMPObjectJSON, Payload.pBound))
         pIAction.Send (this, this.onRSPGeneric.bind (This));
   }

   RMPEditTransform (pRMPObject, pRMPObjectJSON)
   {
      let pIAction = pRMPObject.Request ('TRANSFORM');
      let Payload = pIAction.pRequest;

      if (this.RMCopy_Transform (pRMPObjectJSON, Payload.pTransform))
         pIAction.Send (this, this.onRSPGeneric.bind (This));
   }

   RMPEditAll (pRMPObject, pJSON)
   {
      this.RMPEditName      (pRMPObject, pJSON);
      this.RMPEditResource  (pRMPObject, pJSON);
      this.RMPEditBound     (pRMPObject, pJSON);
      this.RMPEditTransform (pRMPObject, pJSON);
   }

   UpdateRMPObject (aChildren, pRMPObject_Parent)
   {
      this.RMPEditAll (pRMPObject_Parent, aChildren[i]);

      for (let i=0; i < aChildren.length; i++)
      {
         if (aChildren[i].twObjectIx)
         {
            this.RMPEditAll (this.#m_MapRMXItem['73' + '-' + aChildren[i].twObjectIx], aChildren[i]);
         }
         else
         {
            let pIAction = pRMPObject_Parent.Request ('RMPOBJECT_OPEN');
            let Payload = pIAction.pRequest;

            if (this.RMCopy_CName (aChildren[i], Payload.pName) &&
                this.RMCopy_Type ({ pType: { bType: 1, bSubtype: 0, bFiction: 0, bMovable: 0 } }, Payload.pType) &&
                this.RMCopy_Owner ({ pOwner: { twRPersonaIx: 1 } }, Payload.pOwner) &&
                this.RMCopy_Resource ({ pResource: { qwResource: 0, sName: ''} }, aChildren[i], Payload.pResource) &&
                this.RMCopy_Bound (aChildren[i], Payload.pBound) &&
                this.RMCopy_Transform (aChildren[i], Payload.pTransform))
            {
               pIAction.Send (this, Response);
            }
         }

         this.UpdateRMPObject (aChildren[i].aChildren);
      }
   }

   Publish (JSONData)
   {
      if (JSONData.twObjectIx == this.#pRMXRoot.twObjectIx)
      {
         this.UpdateRMPObject (JSONData, this.#pRMXRoot);
      }
      else
      {
//         this.UpdateRMPObject (JSONData.aChildren, this.#pRMXRoot);
      }
   }
};

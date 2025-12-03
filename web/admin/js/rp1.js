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
               if (this.#m_MapRMXItem['73' + '-' + twObjectIx] == undefined)
               {
                  this.#m_MapRMXItem['73' + '-' + twObjectIx] = aPObject[i];
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

   #SortItems (jContainer, jRow, sName)
   {
      jRow.detach ();

      let jRows = jContainer.children ();
      let xCollator = this.xCollator;
      let a = 0;
      let b = jRows.length;

      while (a < b)
      {
         let c = Math.floor ((a + b) / 2);
         let x = xCollator.compare (sName, jRows.eq (c).find ('.tree-label').text ());

         if (x < 0)
            b = c;
         else if (x > 0)
            a = c + 1;
         else a = b = c;
      }

      if (a == jRows.length)
         jContainer.append (jRow);
      else jRows.eq (a).before (jRow);
   }
};

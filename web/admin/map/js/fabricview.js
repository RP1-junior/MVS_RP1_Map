   class ExtractMap extends MV.MVMF.NOTIFICATION
   {
      #m_pFabric;
      #m_pLnG;
      #m_jRoot;
      #m_jBody;
      #m_jRight;
      #m_MapRMXItem;
      #m_wClass_Object;
      #m_twObjectIx;

      static eSTATE =
      {
        NOTREADY : 0,
        READY    : 1,
        REDIRECT : 2,
      };

      eSTATE = ExtractMap.eSTATE;
      constructor (sName, wClass_Object, twObjectIx)
      {
         super ();
         this.#m_wClass_Object = (wClass_Object == 0) ? 71 : wClass_Object;
         this.#m_twObjectIx    = (twObjectIx == 0)  ? 1 : twObjectIx;
         
         this.xCollator = new Intl.Collator ();

         InitMap ();

         this.#m_jRoot = $('.jsRoot');
         this.#m_jBody = $('body');
         this.#m_jRight = $('.jsRight');
         this.#m_jRoot.on ('click', '.jsLevel', this.onClick_Object.bind (this));
         this.#m_MapRMXItem = {};

         this.pRequire = MV.MVMF.Core.Require ('MVRP_Dev,MVRP_Map,MVRP_Fabric');

         if (sName.length == 0)
             sName = 'rp1.msf.json';

         this.#m_pFabric = new MV.MVRP.MSF (sName, MV.MVRP.MSF.eMETHOD.GET);
         this.#m_pFabric.Attach (this);
      }

      destructor ()
      {
         if (this.#m_pLnG)
         {
            for (Item in this.#m_MapRMXItem)
            {
               Item.pRMXObject.Detach (this);
               this.#m_pLnG.Model_Close (Item.pRMXObject);
            }
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
               if (pNotice.pData.pChild.sID == 'RMCObject')
               {
               }
            }
         }
      }
      
      onUpdated (pNotice)
      {
         if (this.ReadyState () == this.eSTATE.READY)
         {
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

      InsertItem (pRMXObject)
      {
         let jTemplate = this.#m_jBody.find ('template#tmpl_navigate');
         let jItem = $(jTemplate[0].content.querySelector ('.jsLevel')).clone();
         let tri = jItem.children('.tree-triangle');
         let jLabel = jItem.find ('.tree-label');
         let wClass_Object = pRMXObject.pSource.pObjectHead.wClass_Object;
         let sName;

         jItem.data ('object', pRMXObject);
         jItem.attr ('twObjectIx', pRMXObject.twObjectIx);
         if (wClass_Object == 71)
         {
            sName = pRMXObject.pName.wsRMCObjectId;
         }
         else if (wClass_Object == 72)
         {
            sName = pRMXObject.pName.wsRMTObjectId;
         }
         else if (wClass_Object == 73)
         {
            sName = pRMXObject.twObjectIx + '';
         }

         jLabel.text (sName);
         jLabel.addClass ('tree-type' + wClass_Object);

         let jParent = this.#m_jRoot.find ('.jsLevel' +'[twObjectIx=' + pRMXObject.twParentIx + ']');
         if (jParent.length == 0) 
         {
            tri.html ('-');
            jParent = this.#m_jRoot;
         } 
         else 
         {
            jItem.addClass ('collapsed');
            let children = jParent.children('.tree-children');
            if (children.length) 
            {
               jParent = children;
            }
         }
         
         jParent.append (jItem);

         this.#SortItems (jParent, jItem, sName);
      }

      EnumItem (pRMXObject, Param)
      {
         this.InsertItem (pRMXObject);
         Param.push (pRMXObject);
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
         else
         {
            let pObjectHead = pNotice.pCreator.pSource.pObjectHead;
            let pRMXItem = this.#m_MapRMXItem[pObjectHead.wClass_Object + '-' + pNotice.pCreator.twObjectIx];
            if (pRMXItem && pRMXItem.pRMXObject.IsReady())
            { 
               if (pRMXItem.bInserted == false)
               {
                  this.InsertItem (pRMXItem.pRMXObject);
                  pRMXItem.bInserted = true;
               }

               let x = [];
               pRMXItem.pRMXObject.Child_Enum ('RMCObject', this, this.EnumItem, x);
               DrawMap (x, pRMXItem.pRMXObject, (pObjectHead.wClass_Object == this.#m_wClass_Object && pNotice.pCreator.twObjectIx == this.#m_twObjectIx));
               pRMXItem.pRMXObject.Child_Enum ('RMTObject', this, this.EnumItem, x);
               pRMXItem.pRMXObject.Child_Enum ('RMPObject', this, this.EnumItem, x);
            } 
         }    
      }

      Exec ()
      {
         let sID;

         if (this.#m_pLnG == null)
         {
            this.#m_pLnG = this.#m_pFabric.GetLnG ("map");
            if (this.#m_wClass_Object == 71)
               sID = 'RMCObject';
            else if (this.#m_wClass_Object == 72)
               sID = 'RMTObject';
            else if (this.#m_wClass_Object == 73)
               sID = 'RMPObject';
            let pRMXObject = this.#m_pLnG.Model_Open (sID, this.#m_twObjectIx)
            this.#m_MapRMXItem[this.#m_wClass_Object + '-' + this.#m_twObjectIx] = 
            {
               bInserted: false,
               pRMXObject: pRMXObject
            };
            pRMXObject.Attach (this);
         }
      }

      onClick_Object (e)
      {
         let jItem = $(e.currentTarget).closest ('.jsLevel');
         let tri = jItem.children ('.tree-triangle');
         let pRMXObject = jItem.data ('object');
         let pObjectHead = pRMXObject.pSource.pObjectHead;

         // Expand/collapse logic
         jItem.toggleClass ('collapsed');

         if (pRMXObject.nChildren > 0)
         {
            if (jItem.hasClass ('collapsed') ) 
            {
               tri.html ('+'); // right
            } 
            else 
            {
               tri.html ('-'); // down
            }
         }
         else 
         {
            tri.html (''); // right
         }
         if (jItem.children ('.tree-children').children ('.jsLevel').length > 0) 
         {
            // Toggle triangle direction
            e.stopPropagation();
            return;
         }

         if (pObjectHead.wClass_Object == 71)
         {
             let aType = [ 'NULL', 'UNIVERSE', 'SUPERCLUSTER', 'GALAXYCLUSTER', 'GALAXY', 'BLACKHOLE', 'NEBULA', 'STARCLUSTER', 'CONSTELLATION', 'STARSYSTEM', 'STAR', 'PLANETSYSTEM', 'PLANET', 'MOON', 'DEBRIS', 'SATELLITE', 'TRANSPORT', 'SURFACE' ];
             
             this.#m_jRight.find ('.jsName').html (pRMXObject.pName.wsRMCObjectId);
             this.#m_jRight.find ('.jsType').html (aType[pRMXObject.pType.bType]);
         }
         else if (pObjectHead.wClass_Object == 72)
         {
             let aType = [ 'NULL', 'ROOT', 'WATER', 'LAND', 'COUNTRY', 'TERRITORY', 'STATE', 'COUNTY', 'CITY', 'COMMUNITY', 'SECTOR', 'PARCEL' ];
             this.#m_jRight.find ('.jsName').html (pRMXObject.pName.wsRMTObjectId);
             this.#m_jRight.find ('.jsType').html (aType[pRMXObject.pType.bType]);
         }
         else if (pObjectHead.wClass_Object == 73)
         {
             this.#m_jRight.find ('.jsName').html ('{ ' + pRMXObject.twObjectIx + ' }');
             this.#m_jRight.find ('.jsType').html ('{ ' + pRMXObject.pType.bType + ' }');
         }
         this.#m_jRight.find ('.jsSubtype').html ('{ ' + pRMXObject.pType.bSubtype + ' }');
         this.#m_jRight.find ('.jsFiction').html ('{ ' + pRMXObject.pType.bFiction + ' }');
         this.UpdateRMXTransform (pRMXObject.pTransform);
         this.UpdateRMXResource  (pRMXObject.pResource);
         if (this.#m_MapRMXItem[pObjectHead.wClass_Object + '-' + pRMXObject.twObjectIx] == undefined)
         {
            this.#m_MapRMXItem[pObjectHead.wClass_Object + '-' + pRMXObject.twObjectIx] =
            {
                bInserted:  true,
                pRMXObject: pRMXObject
            }
            pRMXObject.Attach (this);
         }  
         e.stopPropagation ();
      }

      UpdateRMXResource (pResource)
      {
         let jField = this.#m_jRight.find ('.jsResource');
         jField.find ('.jsResourceIx').html (pResource.qwResource);
         jField.find ('.jsName').html (pResource.sName);
         jField.find ('.jsReference').html (pResource.sReference);
      }

      UpdateRMXTransform (pTransform)
      {
         let jTransform = this.#m_jRight.find ('.jsTransform');
         jTransform.find ('.jsPos').html (pTransform.vPosition.dX + ', ' + pTransform.vPosition.dY + ', ' + pTransform.vPosition.dZ);
         jTransform.find ('.jsRot').html (pTransform.qRotation.dX + ', ' + pTransform.qRotation.dY + ', ' + pTransform.qRotation.dZ + ', ' + pTransform.qRotation.dW);
         jTransform.find ('.jsScale').html (pTransform.vScale.dX + ', ' + pTransform.vScale.dY + ', ' + pTransform.vScale.dZ);
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
/*
Test ()
{
var onResponse = function (pIAction, Param)
{
console.log (pIAction);
}
let pRMTObject = this.#m_pLnG.Model_Open ('RMTObject', 900000001);
let pIAction = pRMTObject.Request ('ADDENDUM');
pIAction.pRequest.sType = 'sector';
pIAction.Send (this, onResponse);
}
*/
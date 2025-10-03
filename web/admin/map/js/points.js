   function quaternionToEulerDeg(x, y, z, w) 
   {
      const q = new THREE.Quaternion(x, y, z, w);
      const euler = new THREE.Euler().setFromQuaternion(q, 'YXZ');
      return [
         THREE.MathUtils.radToDeg(euler.x),
         THREE.MathUtils.radToDeg(euler.y),
         THREE.MathUtils.radToDeg(euler.z)
      ];
   }

function DrawMap (apRMCObject, pRMCObject_Parent, bRoot)
{
   const scale = 0.00000000000000000001;
   let i = 0;

   /* pRMCObject
      translate: pTransform.vPosition.dX, pTransform.vPosition.dY, pTransform.vPosition.dZ
      rotate: pTransform.qRotation.dX, pTransform.qRotation.dY, pTransform.qRotation.dZ
      bound: pTransform.pBound.vMax.dX, pTransform.pBound.vMax.dY, pTransform.pBound.vMax.dZ
   */
   
   let entity_parent = bRoot ? document.querySelector ('a-scene') : document.getElementById ('C-' + pRMCObject_Parent.twRMCObjectIx);

   for (let x = 0; x < apRMCObject.length; x++)
   {
      const pos = []; 
      pos.push (apRMCObject[x].pTransform.vPosition.dX * scale);
      pos.push (apRMCObject[x].pTransform.vPosition.dY * scale);
      pos.push (apRMCObject[x].pTransform.vPosition.dZ * scale);

      const rot = quaternionToEulerDeg(apRMCObject[x].pTransform.qRotation.dX, apRMCObject[x].pTransform.qRotation.dX, apRMCObject[x].pTransform.qRotation.dX, apRMCObject[x].pTransform.qRotation.dW);

      const bounds = [];
      bounds.push (2 * apRMCObject[x].pBound.dX * scale);
      bounds.push (2 * apRMCObject[x].pBound.dY * scale);
      bounds.push (2 * apRMCObject[x].pBound.dZ * scale);

      if (bounds[0] < 0)
         bounds[0] *= -1;
      if (bounds[1] < 0)
         bounds[1] *= -1;
      if (bounds[2] < 0)
         bounds[2] *= -1;

      let colR = ((i % 2) == 0) ? "ff" : "80";
      let colG = (((i >> 1) % 2) == 0) ? "ff" : "80";
      let colB = (((i >> 2) % 2) == 0) ? "ff" : "80";
      i++;

      const entity = document.createElement ('a-entity');
      entity.setAttribute ('id', 'C-' + apRMCObject[x].twRMCObjectIx);
      entity.setAttribute ('position', pos.join (' '));
      entity.setAttribute ('rotation', rot.join (' '));
      entity_parent.appendChild (entity);

      //apRMCObject[x].pProperties.fColor = "#" + colR + colG + colB;
      // Cone
      let fColor = "#" + colR + colG + colB;
      const cone = document.createElement('a-cone');
   // cone.setAttribute('position', '0 0 0');
   // cone.setAttribute('rotation', '0 0 0');
      cone.setAttribute('radius-bottom', 0.2);
      cone.setAttribute('height', 0.5);
      cone.setAttribute('color', fColor);
      entity.appendChild(cone);

      if (apRMCObject[x].pType.bType == 7)
      {
         // Bounding Box (with same rotation)
         const box = document.createElement('a-box');
      // box.setAttribute('position', '0 0 0');
      // box.setAttribute('rotation', '0 0 0');
         box.setAttribute('width', bounds[0] / 1);
         box.setAttribute('height', bounds[1] / 1);
         box.setAttribute('depth', bounds[2] / 1);
         box.setAttribute('material', `color: ${fColor}; wireframe: true; opacity: 0.6`);
         
         entity.appendChild (box);
      }
      else
      {
         // Bounding Box (with same rotation)
         const box = document.createElement('a-sphere');
      // box.setAttribute('position', '0 0 0');
      // box.setAttribute('rotation', '0 0 0');
//               box.setAttribute ('radius', 1);
         box.setAttribute ('scale', bounds.join (' '));
         box.setAttribute ('material', `color: ${fColor}; wireframe: true; opacity: 0.6`);
         
         entity.appendChild (box);
      }

      // Label - using A-Frame text with custom material to override backgrounds
      const label = document.createElement('a-text');
      label.setAttribute('value', apRMCObject[x].pName.wsRMCObjectId);
      label.setAttribute('align', 'center');
      label.setAttribute('color', '#000');
      label.setAttribute('position', '0 0.5 0');
      label.setAttribute('scale', '1 1 1');
      label.setAttribute('side', 'double');
      label.setAttribute('look-at', '[camera]');
      label.setAttribute('baseline', 'center');
      label.setAttribute('wrapCount', '0');
      label.setAttribute('font', 'kelsonsans');
      
      // Override the default text material
      label.setAttribute('material', 'shader: flat; color: #000; transparent: true; opacity: 1');
      
      entity.appendChild(label);
   }
}

function InitMap ()
{
   AFRAME.registerComponent('spawn-cones', {
      init: function () {
      }
   });
}

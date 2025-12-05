const { MVHANDLER } = require ('@metaversalcorp/mvsf');
const fs = require ('fs');
const path = require ('path');

/*******************************************************************************************************************************
**                                                     Class                                                                  **
*******************************************************************************************************************************/

class HndlrRMObjectLibrary extends MVHANDLER
{
   constructor ()
   {
      super 
      (
         'objects', 
         {
            'list': {
               sCB: "List"
            }
         },
         null,
         null,
         null
      );
   }

   List (pConn, Session, pData, fnRSP, fn)
   {
      try
      {
         // Path to the objects directory relative to the server root
         const sObjectsPath = path.join (__dirname, '..', 'web', 'public', 'objects');
         
         // Read the directory
         fs.readdir (sObjectsPath, (err, aFiles) =>
         {
            if (err)
            {
               console.error ('Error reading objects directory:', err);
               fnRSP (fn, { nResult: -1, aResultSet: [] });
               return;
            }

            // Filter for .glb and .gltf files only
            const aObjectFiles = aFiles.filter (sFile => 
               sFile.toLowerCase ().endsWith ('.glb') || 
               sFile.toLowerCase ().endsWith ('.gltf')
            );

            // Return the list of object files
            fnRSP (fn, { nResult: 0, aResultSet: [aObjectFiles] });
         });
      }
      catch (err)
      {
         console.error ('Error in ObjectLibrary.List:', err);
         fnRSP (fn, { nResult: -1, aResultSet: [] });
      }
   }
}

/*******************************************************************************************************************************
**                                                     Initialization                                                         **
*******************************************************************************************************************************/

module.exports = HndlrRMObjectLibrary;

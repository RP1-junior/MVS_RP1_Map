var Service = require('node-windows').Service;

// Create a new service object
var svc = new Service ({
          name: 'MVS_RP1_Map',
          description: 'RP1 Metaversal Map Service.',
          script: 'D:\\MVS_RP1_Map\\server.js'
});

// Listen for the "install" event, which indicates the
// process is available as a service.

svc.on('install',function(){
      svc.start();
});

svc.install ();

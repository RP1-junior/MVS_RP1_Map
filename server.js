const { MVSF } = require('@metaversalcorp/mvsf');
const { InitSQL } = require('./utils.js');
const Settings = require('./settings.json');
const { MVSQL_MYSQL } = require('@metaversalcorp/mvsql_mysql');
const fs = require('fs');
const path = require('path');
const http = require('http');

class MVSF_Map {
  #pServer;
  #pSQL;

  constructor() {
    switch (Settings.SQL.type) {
      case 'MYSQL':
        Settings.SQL.config.host = process.env.MYSQLHOST;
        Settings.SQL.config.port = process.env.MYSQLPORT;
        Settings.SQL.config.user = process.env.MYSQLUSER;
        Settings.SQL.config.password = process.env.MYSQLPASSWORD;
        Settings.SQL.config.database = process.env.MYSQLDATABASE;
        console.log('setting: ', Settings.SQL.config);
        this.#pSQL = new MVSQL_MYSQL(Settings.SQL.config, this.onSQLReady.bind(this));
        break;
      default:
        this.#pSQL = null;
        break;
    }
  }

  onSQLReady(pMVSQL, err) {
    if (pMVSQL) {
      Settings.MVSF.nPort = process.env.PORT || 3000;

      // Create the MVSF server instance (but don't let it listen itself)
      this.#pServer = new MVSF(Settings.MVSF, require('./handler.json'), __dirname, null, 'application/json');

      console.log('SQL Server READY');
      InitSQL(pMVSQL, this.#pServer, Settings.Info);

      // Create a single HTTP server that handles both /fabric.msf and MVSF
      const server = http.createServer((req, res) => {
        if (req.url === '/fabric.msf') {
          const filePath = path.join(__dirname, 'fabric.msf');
          fs.readFile(filePath, (err, data) => {
            if (err) {
              res.writeHead(404, { 'Content-Type': 'text/plain' });
              res.end('File not found');
            } else {
              res.writeHead(200, { 'Content-Type': 'application/octet-stream' });
              res.end(data);
            }
          });
        } else {
          // Let MVSF handle all other requests
          this.#pServer.OnRequest(req, res);
        }
      });

      server.listen(Settings.MVSF.nPort, () => {
        console.log(`Server running on port ${Settings.MVSF.nPort}`);
      });

    } else {
      console.log('SQL Server Connect Error: ', err);
    }
  }
}

new MVSF_Map();

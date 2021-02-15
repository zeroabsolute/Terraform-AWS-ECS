const Http = require('http');

const app = require('./app');
const config = require('./config');

const server = Http.createServer(app);

server.listen(config.port, (error) => {
  if (error) {
    console.log(`
          \n\n
          --------------------------------
          --------------------------------

          API:

          Status: Error
          Log: ${error}

          --------------------------------
          --------------------------------
          \n\n`
    );
  } else {
    console.log(`
          \n\n
          --------------------------------
          --------------------------------

          API:

          Status: OK
          Port: ${config.port}

          --------------------------------
          --------------------------------
          \n\n`
    );
  }
});


module.exports = server;
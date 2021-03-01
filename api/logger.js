const Bunyan = require('bunyan');

const config = require('./config');
let logger = null;

/**
 * Express logger config.
 */

const expressLoggerConfig = {
  name: config.appName,
  streams: [
    {
      level: 'debug',
      stream: process.stdout,
      obfuscate: [
        'body.password',
      ],
    }
  ],
};

/**
 * Generates a Bunyan logger service.
 * Will be called during server initialization.
 */

const initLoggerService = () => {
  logger = Bunyan.createLogger({
    name: config.appName,
    streams: [
      {
        level: 'debug',
        stream: process.stdout,
      },
    ],
  });
};

module.exports = {
  expressLoggerConfig,
  initLoggerService,
  getLogger: () => logger,
}

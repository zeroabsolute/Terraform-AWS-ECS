const Express = require('express');
const BodyParser = require('body-parser');
const Cors = require('cors');
const { Pool } = require('pg');
const Crypto = require('crypto');
const ExpressBunyanLogger = require('express-bunyan-logger');
const Os = require('os-utils');

const config = require('./config');
const { getLogger, initLoggerService, expressLoggerConfig } = require('./logger');

const app = Express();
const router = new Express.Router();

initLoggerService();

const pgClient = new Pool({
  host: config.dbHost,
  port: config.dbPort,
  user: config.dbUser,
  password: config.dbPassword,
  database: config.dbName,
});

pgClient.on('error', (e) => {
  getLogger().debug(e);
});

pgClient.query('CREATE TABLE IF NOT EXISTS books (title varchar(128))')
  .catch((err) => getLogger().debug(err));

app.use(Cors());
app.use(BodyParser.json({ limit: '10mb' }));
app.use(BodyParser.urlencoded({ limit: '10mb', extended: false }));
app.use(ExpressBunyanLogger(expressLoggerConfig));
app.use(router);

router.route('/health').get(
  async (_req, res) => {
    const cpuUtilization = await getCpuUtilizationPromise();
    const status = cpuUtilization > 0.5 ? 503 : 200;
    const statusCode = cpuUtilization > 0.5 ? 'Not OK' : 'OK';

    res.status(status).json({
      appName: 'API',
      version: process.env.npm_package_version,
      status: statusCode,
      metadata: {
        cpuUtilization,
      }
    });
  }
);

const getCpuUtilizationPromise = () => new Promise((resolve) => {
  Os.cpuUsage((percentage) => {
    resolve(percentage);
  })
});

router.route('/books').get(
  async (_req, res) => {
    try {
      const result = await pgClient.query('SELECT * FROM books');
      res.status(200).json(result.rows);
    } catch (e) {
      getLogger().debug(e);
      res.status(500).json(e);
    }
  }
);

router.route('/books').post(
  async (req, res) => {
    try {
      if (!req.body.title) {
        throw new Error('Invalid params');
      }

      const result = await pgClient.query(
        'INSERT INTO books(title) VALUES($1) RETURNING *',
        [req.body.title]
      );
      res.status(201).json(result.rows[0]);
    } catch (e) {
      getLogger().debug(e);
      res.status(500).json(e);
    }
  }
);

router.route('/generate-cpu-load').post(
  async (req, res) => {
    try {
      res.sendStatus(202);
      for (let i = 0; i < 5000; i++) {
        Crypto.pbkdf2(
          Crypto.randomBytes(32).toString('hex'),
          Crypto.randomBytes(32).toString('hex'),
          100000,
          64,
          'sha512',
          () => {},
        );
      }
    } catch (e) {
      getLogger().debug(e);
      res.status(500).json(e);
    }
  }
);

// Catch all unhandled errors and log them
process.on('unhandledRejection', (reason) => {
  throw reason;
});

process.on('uncaughtException', (error) => {
  getLogger().debug(error);
});

module.exports = app;
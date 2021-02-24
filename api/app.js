const Express = require('express');
const BodyParser = require('body-parser');
const Cors = require('cors');
const { Pool } = require('pg');

const config = require('./config');

const app = Express();
const router = new Express.Router();

const pgClient = new Pool({
  host: config.dbHost,
  port: config.dbPort,
  user: config.dbUser,
  password: config.dbPassword,
  database: config.dbName,
});

pgClient.on('error', () => {
  console.log('Error connecting to Postgres');
});

pgClient.query('CREATE TABLE IF NOT EXISTS books (title varchar(128))')
  .catch((err) => console.log(err));

app.use(BodyParser.json({ limit: '10mb' }));
app.use(BodyParser.urlencoded({ limit: '10mb', extended: false }));
app.use(router);
app.use(Cors());

router.route('/health').get(
  (_req, res) => {
    res.status(200).json({
      appName: 'API',
      version: process.env.npm_package_version,
      status: 'OK',
    });
  }
);

router.route('/books').get(
  async (_req, res) => {
    try {
      const result = await pgClient.query('SELECT * FROM books');
      res.status(200).json(result.rows);
    } catch (e) {
      console.log(e);
      res.status(500).json(e);
    }
  }
);

router.route('/books').post(
  async (req, res) => {
    try {
      const result = await pgClient.query(
        'INSERT INTO books(title) VALUES($1) RETURNING *',
        [req.body.title]
      );
      res.status(201).json(result.rows[0]);
    } catch (e) {
      console.log(e);
      res.status(500).json(e);
    }
  }
);

module.exports = app;
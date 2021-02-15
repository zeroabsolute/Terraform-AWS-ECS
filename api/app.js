const Express = require('express');
const BodyParser = require('body-parser');
const Cors = require('cors');

const app = Express();
const router = new Express.Router();

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

module.exports = app;
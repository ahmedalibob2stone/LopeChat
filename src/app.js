const express = require('express');
const bodyParser = require('body-parser');
const rateLimit = require('express-rate-limit');

const authRoutes = require('./routes/auth.routes');
const agoraRoutes = require('./routes/agora.routes');

const app = express();
app.set('trust proxy', 1);
app.use(bodyParser.json());

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
});
app.use(limiter);

app.use('/auth', authRoutes);
app.use('/agora', agoraRoutes);

app.get('/', (req, res) => res.send('🚀 Server is running!'));

module.exports = app;

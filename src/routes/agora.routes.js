const express = require('express');
    const { getAgoraToken } = require('../services/agora.service');
const router = express.Router();

router.get('/get-token', getAgoraToken);

module.exports = router;

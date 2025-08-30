const { RtcTokenBuilder, RtcRole, appID, appCertificate, expireTimeInSeconds } = require('../config/agora');

exports.getAgoraToken = (req, res) => {
  const channelName = req.query.channelId;
  const uid = parseInt(req.query.uid);

  if (!channelName || isNaN(uid)) {
    return res.status(400).json({ error: 'channelId و uid مطلوبين' });
  }

  const role = RtcRole.PUBLISHER;
  const currentTimestamp = Math.floor(Date.now() / 1000);
   const tokenExpire = expireTimeInSeconds || 3600;
  const privilegeExpireTime = currentTimestamp + tokenExpire;

  const token = RtcTokenBuilder.buildTokenWithUid(appID,
  appCertificate, channelName, uid,
  role, privilegeExpireTime
  );
  console.log('Generated token:', token);
  res.json({ token });
};

const { RtcTokenBuilder, RtcRole } = require('agora-token');

module.exports = {
  RtcTokenBuilder,
  RtcRole,
  appID: process.env.AGORA_APP_ID,
  appCertificate: process.env.AGORA_APP_CERTIFICATE,
  expireTimeInSeconds: 3600,
};

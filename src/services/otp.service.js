const { v4: uuidv4 } = require('uuid');
const redisClient = require('../config/redis');
const twilioClient = require('../config/twilio');
const admin = require('../config/firebase');
const pTimeout = require('p-timeout');

console.log(admin.app().name);
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

exports.sendOtp = async (req, res) => {
  const { phoneNumber } = req.body;

  if (!phoneNumber || !phoneNumber.startsWith('+')) {
    return res.status(400).json({ error: 'Invalid phone number format' });
  }
  const otp = generateOTP();
  console.log(`Generated OTP: ${otp} for number: ${phoneNumber}`);

  try {
    await redisClient.setEx(phoneNumber, 60, otp);


const message = await twilioClient.messages.create({
      body: `رمز التحقق الخاص بك: ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phoneNumber,
    });

console.log(message.sid);


    res.json({
      success: true,
      message: 'OTP sent successfully',
      sid: message.sid,
    });
  } catch (error) {
    console.error('Twilio send error:', error);
    res.status(500).json({ error: 'Failed to send OTP', details: error.message });
  }
};
function generateUUID() {
  return 'xxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}
exports.verifyOtp = async (req, res) => {
  const { phoneNumber, otp } = req.body;
  const attemptsKey = `otp_attempts_${phoneNumber}`;

  try {
    let attempts = await redisClient.get(attemptsKey);
    attempts = attempts ? parseInt(attempts, 10) : 0;

    if (attempts >= 5) {
      return res.status(429).json({ error: 'Maximum number of attempts exceeded. Please try again later.' });
    }

    const storedOtp = await redisClient.get(phoneNumber);

    if (!storedOtp || storedOtp !== otp) {

      await redisClient.setEx(attemptsKey, 300, String(attempts + 1));
      return res.status(401).json({ error: 'Incorrect verification code' });
    }

    await redisClient.del(phoneNumber);
    await redisClient.del(attemptsKey);

    let userRecord;
    try {
userRecord = await pTimeout(
  admin.auth().getUserByPhoneNumber(phoneNumber),
      15000,
  'Firebase Auth request timed out'
);    } catch (error) {
      if (error.code === "auth/user-not-found") {
        const uid = uuidv4();
        userRecord = await admin.auth().createUser({ uid, phoneNumber });
      } else {
        throw error;
      }
    }

    const customToken = await admin.auth().createCustomToken(userRecord.uid);
    res.json({ uid: userRecord.uid, token: customToken });

  } catch (error) {
    console.error('verifyOtp error:', error);
    res.status(500).json({ error: 'Failed to create token', details: error.message });
  }
};
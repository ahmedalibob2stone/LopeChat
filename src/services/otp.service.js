const redisClient = require('../config/redis');
const twilioClient = require('../config/twilio');
const admin = require('../config/firebase');

function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

exports.sendOtp = async (req, res) => {
  const { phoneNumber } = req.body;

  if (!phoneNumber || !phoneNumber.startsWith('+')) {
    return res.status(400).json({ error: 'Invalid phone number format' });
  }

  const otp = process.env.TEST_MODE === 'true' ? '123456' : generateOTP();
  console.log(`Generated OTP: ${otp} for number: ${phoneNumber}`);

  try {
    // Store OTP in Redis
    await redisClient.setEx(phoneNumber, 300, otp);

    if (process.env.TEST_MODE === 'true') {
      return res.json({
        success: true,
        message: 'OTP mocked in test mode',
        otp, // Return OTP directly for testing (optional)
      });
    }

    // Production mode → send via Twilio
    const message = await twilioClient.messages.create({
      body: `Your verification code is: ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phoneNumber,
    });

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

exports.verifyOtp = async (req, res) => {
  const { phoneNumber, otp } = req.body;

  const attemptsKey = `otp_attempts_${phoneNumber}`;

  try {
    let attempts = await redisClient.get(attemptsKey);
    attempts = attempts ? parseInt(attempts) : 0;

    if (attempts >= 5) {
      return res.status(429).json({ error: 'Maximum number of attempts exceeded. Please try again later.' });
    }

    const storedOtp = await redisClient.get(phoneNumber);

    if (!storedOtp || storedOtp !== otp) {
      await redisClient.setEx(attemptsKey, 300, attempts + 1);
      return res.status(401).json({ error: 'Incorrect verification code' });
    }

    await redisClient.del(phoneNumber);
    await redisClient.del(attemptsKey);

    const uid = phoneNumber.replace('+', '');
    const customToken = await admin.auth().createCustomToken(uid);

    res.json({ uid, token: customToken });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create token', details: error.message });
  }
};

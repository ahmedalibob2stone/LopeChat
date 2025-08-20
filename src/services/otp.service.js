const redisClient = require('../config/redis');
const twilioClient = require('../config/twilio');
const admin = require('../config/firebase');

function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

exports.sendOtp = async (req, res) => {
  const { phoneNumber } = req.body;

  const otp = generateOTP();


  try {
    await redisClient.setEx(phoneNumber, 300, otp);
    await twilioClient.messages.create({
      body: `رمز التحقق الخاص بك: ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phoneNumber,
    });

    res.json({ success: true, message: 'تم إرسال OTP' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.verifyOtp = async (req, res) => {
  const { phoneNumber, otp } = req.body;

  const attemptsKey = `otp_attempts_${phoneNumber}`;

  try {
    let attempts = await redisClient.get(attemptsKey);
    attempts = attempts ? parseInt(attempts) : 0;

    if (attempts >= 5) {
      return res.status(429).json({ error: 'تم تجاوز عدد المحاولات المسموح بها. حاول لاحقاً.' });
    }

    const storedOtp = await redisClient.get(phoneNumber);

    if (!storedOtp || storedOtp !== otp) {
      await redisClient.setEx(attemptsKey, 300, attempts + 1);
      return res.status(401).json({ error: 'رمز التحقق غير صحيح' });
    }

    await redisClient.del(phoneNumber);
    await redisClient.del(attemptsKey);

    const uid = phoneNumber.replace('+', '');
    const customToken = await admin.auth().createCustomToken(uid);

    res.json({ uid, token: customToken });
  } catch (error) {
    res.status(500).json({ error: 'فشل إنشاء التوكن', details: error.message });
  }
};


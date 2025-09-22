require('dotenv').config();
const twilio = require('twilio');

const twilioClient = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

  async function sendOTP() {
  const phoneNumber = '+967739506810';
  const otp = Math.floor(100000 + Math.random() * 900000);

  try {
    const message = await twilioClient.messages.create({
      body: `رمز التحقق الخاص بك هو: ${otp}`,
      from: `whatsapp:${process.env.TWILIO_WHATSAPP_NUMBER}`,
      to: `whatsapp:${phoneNumber}`
    });

    console.log('OTP Sent:', otp);
    console.log('Message SID:', message.sid);
  } catch (error) {
    console.error('Error sending OTP:', error.message);
  }
}

sendOTP();

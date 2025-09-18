// تحميل متغيرات البيئة من .env
require('dotenv').config();

const twilio = require('twilio');

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const fromNumber = process.env.TWILIO_PHONE_NUMBER;
const toNumber = "+967739506810";

// التحقق من أن المتغيرات تم قراءتها
console.log("SID:", accountSid);
console.log("TOKEN:", authToken ? "Loaded" : "Missing");
console.log("FROM:", fromNumber);

const client = twilio(accountSid, authToken);

(async () => {
  try {
    const message = await client.messages.create({
      body: "Test OTP message from LopeChat",
      from: fromNumber,
      to: toNumber,
    });
    console.log("✅ Message sent successfully!");
    console.log("SID:", message.sid);
    console.log("Status:", message.status);
  } catch (error) {
    console.error("❌ Failed to send message:");
    console.error(error);
  }
})();

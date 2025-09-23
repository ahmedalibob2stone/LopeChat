const fs = require('fs');
const admin = require('firebase-admin');
const path = require('path');

const serviceAccountPath = path.join('/etc/secrets', 'SERVICE_ACCOUNTKEY.JSON');

// اقرأ محتوى الملف JSON
const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
//module.exports = { admin, firestore: admin.firestore() };


const admin = require('firebase-admin');
const serviceAccount = require('../../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
module.exports = admin;
//module.exports = { admin, firestore: admin.firestore() };


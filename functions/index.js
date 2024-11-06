const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendProductUpdateNotification = functions.firestore
  .document('Items/{itemId}')
  .onWrite(async (change, context) => {
    const lojaId = change.after.data().lojaId;

    const tokensSnapshot = await admin.firestore()
      .collection('favoritos')
      .doc(lojaId)
      .collection('tokens')
      .get();

    const tokens = tokensSnapshot.docs.map(doc => doc.data().token);

    if (tokens.length > 0) {
      const payload = {
        notification: {
          title: 'Vitrine',
          body: 'Obaaa, sua vitrine favorita acaba de receber novidades quentinhas!! 🔥',
        },
      };

      await admin.messaging().sendToDevice(tokens, payload);
    }
  });

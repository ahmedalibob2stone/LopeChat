import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/privacy/advanced/advanced_privacy_model.dart';
import 'advanced_privacy_datasource.dart';

class AdvancedPrivacyRemoteDataSourceImpl
    implements AdvancedPrivacyRemoteDataSource {
  final FirebaseFirestore firestore;

  AdvancedPrivacyRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> setBlockUnknownSenders({
    required String uid,
    required bool value,
  }) async {
    await firestore.collection('user').doc(uid).set({
      'privacy': {
        'advanced': {
          'blockUnknownSenders': value,
        },
      },
    }, SetOptions(merge: true));
  }

  @override
  Future<AdvancedPrivacyModel> getBlockUnknownSenders(String uid) async {
    final doc = await firestore.collection('user').doc(uid).get();

    if (!doc.exists) {
      return const AdvancedPrivacyModel(blockUnknownSenders: false);
    }

    final data = doc.data();

    final bool blockUnknownSenders = data?['privacy']?['advanced']?['blockUnknownSenders'] ?? false;

    return AdvancedPrivacyModel(blockUnknownSenders: blockUnknownSenders);
  }
}

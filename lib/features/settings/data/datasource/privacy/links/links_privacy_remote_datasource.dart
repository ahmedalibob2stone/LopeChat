import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/privacy/links/model/links_privacy_model.dart';

abstract class LinksPrivacyRemoteDataSource {
  Future<LinksPrivacyModel?> getLinksPrivacy(String uid);
  Future<void> setLinksPrivacy(String uid, LinksPrivacyModel model);
}

class LinksPrivacyRemoteDataSourceImpl implements LinksPrivacyRemoteDataSource {
  final FirebaseFirestore firestore;

  LinksPrivacyRemoteDataSourceImpl(this.firestore);

  @override
  Future<LinksPrivacyModel?> getLinksPrivacy(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    final data = doc.data()?['privacy']?['links_visibility'];
    if (data == null) return null;

    return LinksPrivacyModel.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> setLinksPrivacy(String uid, LinksPrivacyModel model) async {
    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'links_visibility': model.toMap(),
      }
    }, SetOptions(merge: true));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/privacy/privacy_profile/privacy_profile_model.dart';

abstract class ProfilePrivacyRemoteDataSource {
  Future<ProfileModel> getProfilePrivacy(String userId);
  Future<void> updateProfilePrivacy(String userId, ProfileModel model);
}


class ProfilePrivacyRemoteDataSourceImpl implements ProfilePrivacyRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfilePrivacyRemoteDataSourceImpl(this.firestore);

  @override
  Future<ProfileModel> getProfilePrivacy(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    final data = doc.data();

    if (data == null) {
      throw Exception('User data not found');
    }

    final profileData = data['privacy']?['profile'];

    if (profileData == null || profileData is! Map<String, dynamic>) {
      return const ProfileModel(
        visibility: 'everyone',
        exceptUids: [],
      );
    }

    return ProfileModel.fromMap(profileData);
  }

  @override
  Future<void> updateProfilePrivacy(String userId, ProfileModel model) async {
    await firestore.collection('users').doc(userId).set({
      'privacy': {
        'profile': model.toMap(),
      }
    }, SetOptions(merge: true));
  }
}


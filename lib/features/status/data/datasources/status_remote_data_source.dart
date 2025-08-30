import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import '../../../user/model/user_model/user_model.dart';
import '../../../../storsge/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/utils/utills.dart';
import '../model/status/status.dart';
import '../model/statusmodel/status_model.dart';

final statusRemoteDataSourceProvider = Provider<StatusRemoteDataSource>((ref) {
  return StatusRemoteDataSource(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
    storageRepo: ref.read(FirebaseStorageRepositoryProvider), // ✅ هذا هو الصح
  );
});


class StatusRemoteDataSource {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final Ref ref;
  final FirebaseStorageRepository storageRepo;

  StatusRemoteDataSource({
    required this.fire,
    required this.auth,
    required this.ref,
    required this.storageRepo
  });

  Future<void> uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required String statusMessage,
  }) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      // لا تضع ShowSnackBar هنا، بل ترمي استثناء ليتعامل معها الـ UI
      throw Exception('User not logged in');
    }

    final uid = currentUser.uid;

    var statusesSnapshot = await fire
        .collection('status')
        .where('uid', isEqualTo: uid)
        .get();

    String statusId;
    List<String> statusImageUrls;
    List<String> messages;

    if (statusesSnapshot.docs.isNotEmpty) {
      statusId = statusesSnapshot.docs[0].id;
      var status = StatusModel.fromMap(statusesSnapshot.docs[0].data());
      statusImageUrls = status.photoUrls;
      messages = status.messages;
    } else {
      statusId = const Uuid().v1();
      statusImageUrls = [];
      messages = [];
    }

    String imageUrl = await _uploadImage(statusId, uid, statusImage);

    statusImageUrls.add(imageUrl);
    messages.add(statusMessage);

    List<String> uidWhoCanSee = await _getUidWhoCanSee();

    await _saveStatus(
      uid: uid,
      username: username,
      phoneNumber: phoneNumber,
      profilePic: profilePic,
      statusId: statusId,
      statusImageUrls: statusImageUrls,
      messages: messages,
      uidWhoCanSee: uidWhoCanSee,
    );
  }


  Future<String> _uploadImage(String statusId, String uid, File statusImage) async {
    return await storageRepo.storeFiletofirstorage('/status/$statusId$uid', statusImage);

  }

  Future<List<String>> _getUidWhoCanSee() async {
    List<Contact> contacts = [];
    List<String> uidWhoCanSee = [];
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }

    for (var contact in contacts) {
      if (contact.phones.isNotEmpty) {
        var userDataFirebase = await fire
            .collection('users')
            .where('phoneNumber',
            isEqualTo: contact.phones[0].number.replaceAll(' ', ''))
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          final currentUserUid = auth.currentUser!.uid;
          var firebaseContact =
          UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(firebaseContact.uid);
          uidWhoCanSee.add(currentUserUid); // Add current user too
        }
      }
    }
    return uidWhoCanSee;
  }
  Future<List<String>> getStatusImageUrls(String uid, String imageUrl) async {
    List<String> statusImageUrls = [];
    var statusesSnapshot = await fire
        .collection('status')
        .where('uid', isEqualTo: uid)
        .get();

    if (statusesSnapshot.docs.isNotEmpty) {
      Status status = Status.fromMap(statusesSnapshot.docs[0].data());
      statusImageUrls = status.PhotoUrl;
      statusImageUrls.add(imageUrl);
      await fire.collection('status').doc(statusesSnapshot.docs[0].id).update({
        'photoUrl': statusImageUrls,
      });
    } else {
      statusImageUrls = [imageUrl];
    }
    return statusImageUrls;
  }

  Future<void> _saveStatus({
    required String uid,
    required String username,
    required String phoneNumber,
    required String profilePic,
    required String statusId,
    required List<String> statusImageUrls,
    required List<String> messages,
    required List<String> uidWhoCanSee,
  }) async {
    StatusModel status = StatusModel(
      uid: uid,
      username: username,
      phoneNumber: phoneNumber,
      photoUrls: statusImageUrls,
      createdAt: Timestamp.now(),
      profilePic: profilePic,
      statusId: statusId,
      messages: messages,
      whoCanSee: uidWhoCanSee,
    );

    await fire.collection('status').doc(statusId).set(
      status.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<List<StatusModel>> getStatus() async {
    List<StatusModel> statusData = [];
    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      } else {
        throw Exception('Contact permission denied');
      }

      List<String> phoneNumbers = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map((contact) => contact.phones[0].number.replaceAll(' ', ''))
          .toList();

      final currentUserPhone = auth.currentUser?.phoneNumber;
      if (currentUserPhone == null) throw Exception('User not authenticated');

      phoneNumbers.add(currentUserPhone.replaceAll(' ', ''));

      for (int i = 0; i < phoneNumbers.length; i += 30) {
        var batch = phoneNumbers.sublist(
          i,
          i + 30 > phoneNumbers.length ? phoneNumbers.length : i + 30,
        );

        var statusSnapshot = await fire
            .collection('status')
            .where('phoneNumber', whereIn: batch)
            .where(
          'createdAt',
          isGreaterThan: DateTime.now()
              .subtract(const Duration(hours: 24))
              .millisecondsSinceEpoch,
        )
            .get();

        for (var tempData in statusSnapshot.docs) {
          StatusModel tempStatus = StatusModel.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch status: $e');
    }

    return statusData;
  }


  Future<bool> deleteStatus(int index, List<String> photoUrls) async {
    try {
      await FirebaseFirestore.instance
          .collection('statuses')
          .doc(photoUrls[index])
          .delete();

      return true;
    } catch (e) {
      print('Error deleting status: $e');
      return false;
    }
  }
}

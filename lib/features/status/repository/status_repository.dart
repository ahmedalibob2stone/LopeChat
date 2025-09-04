import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../common/utils/utills.dart';

import '../../../storsge/repository.dart';
import '../../user/data/user_model/user_model.dart';
import '../data/model/status/status.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
  auth: FirebaseAuth.instance,
  fire: FirebaseFirestore.instance,
  ref: ref,
  uid: FirebaseAuth.instance.currentUser!.uid

));

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fire;
  final Ref ref;
  final String uid;
  StatusRepository({
    required this.auth,
    required this.fire,
    required this.ref,
    required this.uid
  });


  Future<void> uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
    required String statusMessage,

  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        ShowSnakBar(context: context, content: 'User not logged in');
        return;
      }

      String uid = currentUser.uid;

      // Fetch the existing status document for the current user
      var statusesSnapshot = await fire
          .collection('status')
          .where('uid', isEqualTo: uid)
          .get();

      String statusId;
      List<String> statusImageUrls;
      List<String> messages;

      if (statusesSnapshot.docs.isNotEmpty) {
        // Use the existing statusId if the status exists
        statusId = statusesSnapshot.docs[0].id;
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.PhotoUrl;
        messages = status.massage;
      } else {
        // Generate a new statusId if no status exists
        statusId = const Uuid().v1();
        statusImageUrls = [];
        messages = [];
      }

      // Upload the new image and get the URL
      String imageUrl = await _uploadImage(statusId, uid, statusImage);

      // Append the new image URL and message
      statusImageUrls.add(imageUrl);
      messages.add(statusMessage);

      // Get the list of UIDs who can see the status
      List<String> uidWhoCanSee = await _getUidWhoCanSee();

      // Save or update the status
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
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }


  Future<String> _uploadImage(String statusId, String uid, File statusImage) async {
    return await ref.read(FirebaseStorageRepositoryProvider).storeFiletofirstorage(
      '/status/$statusId$uid',
      statusImage,
    );
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
            .where(
          'phoneNumber',
          isEqualTo: contact.phones[0].number.replaceAll(' ', ''),
        )
            .get();
        if (userDataFirebase.docs.isNotEmpty) {
          final currentUser = auth.currentUser!.uid;
          var firebaseContact = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(firebaseContact.uid);
          (uidWhoCanSee.add(currentUser)

          );



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
    Status status = Status(
      uid: uid,
      username: username,
      phoneNumber: phoneNumber,
      PhotoUrl: statusImageUrls,
      createdAt: Timestamp.now(),
      profilePic: profilePic,
      statusId: statusId,
      massage: messages,
      whoCanSee: uidWhoCanSee,
    );

    await fire.collection('status').doc(statusId).set(
      status.toMap(),
      SetOptions(merge: true), // Use merge to update the existing document
    );
  }



//'package:cloud_firestore/src/query.dart:'failed assertion:line 774 pos 11:'(operator !='in' && operator !='array-contains-any') || (value as iterable).length <=30':'in' filters support a maximum of 30 elements in the value[iterable]





//'package:cloud_firestore/src/query.dart:'failed assertion:line 774 pos 11:'(operator !='in' && operator !='array-contains-any') || (value as iterable).length <=30':'in' filters support a maximum of 30 elements in the value[iterable]

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];

      // Request permission to access contacts
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      } else {
        ShowSnakBar(context: context, content: 'Contact permission denied');
        return statusData; // Return early if permission is denied
      }

      // Normalize and extract phone numbers
      List<String> phoneNumbers = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map((contact) => contact.phones[0].number.replaceAll(' ', ''))
          .toList();

      // Add the current user's phone number to the list
      phoneNumbers.add(auth.currentUser!.phoneNumber!.replaceAll(' ', ''));

      // Split phone numbers into batches of 30
      for (int i = 0; i < phoneNumbers.length; i += 30) {
        var batch = phoneNumbers.sublist(
          i,
          i + 30 > phoneNumbers.length ? phoneNumbers.length : i + 30,
        );

        // Firestore query for status updates
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
          Status tempStatus = Status.fromMap(tempData.data());
          // Check if the current user is allowed to see the status
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);

          }
        }
      }
    } catch (e) {
      // Display an error message if something goes wrong
      ShowSnakBar(context: context, content: e.toString());
    }
    return statusData;
  }


  Future<void> deleteStatus(int index,List<String>photoUrls,BuildContext context) async {
    // Remove from Firestore
    try {
      await FirebaseFirestore.instance

          .collection('statuses')
          .doc(photoUrls[index]) // Assuming the document ID is the URL
          .delete();

      // Remove from local list
     // setState(() {
       // widget.photoUrls.removeAt(index);
        //widget.massage.removeAt(index);
        //_initStoryItems(); // Rebuild story items
      //});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status deleted successfully')),
      );
    } catch (e) {
      print('Error deleting status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete status')),
      );
    }
  }
}





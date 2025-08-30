
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/model/user_model/user_model.dart';

class FirebaseContactDataSource{
  final FirebaseFirestore firestore;
  FirebaseContactDataSource({required this.firestore});
  Future<List<List<UserModel>>> getAllContacts() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];

    try {
      List<Contact> phoneContacts = [];
      if (await FlutterContacts.requestPermission()) {
        phoneContacts = await FlutterContacts.getContacts(withProperties: true);
      }

      // Fetch users from Firebase
      List<UserModel> firebaseContacts = [];
      var userCollection = await firestore.collection('users').get();
      for (var document in userCollection.docs) {
        firebaseContacts.add(UserModel.fromMap(document.data()));
      }

      List<UserModel> appContacts = [];
      List<UserModel> nonAppContacts = [];

      for (var contact in phoneContacts) {
        String phoneNumber = contact.phones.isNotEmpty
            ? contact.phones.first.number.replaceAll(' ', '')
            : '';
        bool isAppUser = false;

        for (var firebaseContact in firebaseContacts) {
          if (firebaseContact.phoneNumber == phoneNumber) {
            appContacts.add(firebaseContact);
            isAppUser = true;

            break;
          }
        }

        if (!isAppUser) {
          nonAppContacts.add(UserModel(
            name: contact.displayName,
            phoneNumber: phoneNumber,
            uid: '',
            profile: '',
            isOnline: 'false', groupId: [], statu: '', blockedUsers: [], lastSeen: '',
          ));
        }
      }

      return [[], []];

    } catch (e) {
      log(e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }

  Future<List<UserModel>> getAppContacts() async {
    List<UserModel> firebaseContacts = [];
    List<Contact> phoneContacts = [];

    try {
      // Step 1: طلب صلاحية الوصول إلى جهات الاتصال
      if (await FlutterContacts.requestPermission()) {
        phoneContacts = await FlutterContacts.getContacts(withProperties: true);
      }

      // Step 2: جلب جميع المستخدمين من Firebase
      var userCollection = await firestore.collection('users').get();
      for (var document in userCollection.docs) {
        firebaseContacts.add(UserModel.fromMap(document.data()));
      }

      // Step 3: مقارنة جهات الاتصال المحلية بمستخدمي التطبيق
      List<UserModel> appContacts = [];

      for (var contact in phoneContacts) {
        String phoneNumber = contact.phones.isNotEmpty
            ? contact.phones.first.number.replaceAll(' ', '')
            : '';

        for (var firebaseContact in firebaseContacts) {
          if (firebaseContact.phoneNumber == phoneNumber) {
            appContacts.add(firebaseContact);
            break;
          }
        }
      }

      return appContacts;
    } catch (e) {
      log('Error: ${e.toString()}');
      return [];
    }
  }

}
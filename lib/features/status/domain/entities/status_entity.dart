import 'package:cloud_firestore/cloud_firestore.dart';

class StatusEntity {
  final String uid;
  final String username;
  final List<String> messages;
  final String phoneNumber;
  final List<String> photoUrls;
  final String profilePic;
  final Timestamp createdAt;
  final String statusId;
  final List<String> whoCanSee;

  StatusEntity({
    required this.uid,
    required this.username,
    required this.messages,
    required this.phoneNumber,
    required this.photoUrls,
    required this.profilePic,
    required this.createdAt,
    required this.statusId,
    required this.whoCanSee,
  });
}

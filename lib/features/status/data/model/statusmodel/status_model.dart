import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/status_entity.dart';

class StatusModel extends StatusEntity {
  StatusModel({
    required super.uid,
    required super.username,
    required super.messages,
    required super.phoneNumber,
    required super.photoUrls,
    required super.profilePic,
    required super.createdAt,
    required super.statusId,
    required super.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'massage': messages,
      'phoneNumber': phoneNumber,
      'PhotoUrl': photoUrls,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      messages: List<String>.from(map['massage'] ?? []),
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrls: List<String>.from(map['PhotoUrl'] ?? []),
      createdAt: Timestamp.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee'] ?? []),
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';

class Status{
final String uid;
final String username;
final List<String> massage;
final String phoneNumber;
final List<String> PhotoUrl;
final String profilePic;
final Timestamp createdAt;
final String statusId;
final List<String> whoCanSee;


  Status({required this.uid,required this.username ,  required this.massage,required this.phoneNumber,required this.PhotoUrl
    ,required this.profilePic,required this.createdAt,required this.statusId,
    required this.whoCanSee,

  });
Map<String, dynamic> toMap() {
  return {
    'uid': uid,
    'username': username,
    'massage': massage,
    'phoneNumber':phoneNumber ,
    'PhotoUrl': PhotoUrl,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'profilePic': profilePic,
    'statusId': statusId,
    'whoCanSee': whoCanSee,

  };
}

factory Status.fromMap(Map<String, dynamic> map) {
  return Status(
    uid: map['uid'] ?? '',
    username: map['username'] ?? '',
    massage:  List<String>.from(map['massage']),
    phoneNumber: map['phoneNumber'] ?? '',
    PhotoUrl: List<String>.from(map['PhotoUrl']),
    createdAt: Timestamp.fromMillisecondsSinceEpoch(map['createdAt']),
    profilePic: map['profilePic'] ?? '',
    statusId: map['statusId'] ?? false,
    whoCanSee: List<String>.from(map['whoCanSee']),


  );
}
}


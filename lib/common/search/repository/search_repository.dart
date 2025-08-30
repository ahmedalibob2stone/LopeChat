
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final searchRepositoryProvider =Provider(
        (ref) {
      return SearchRepository(fire: FirebaseFirestore.instance,auth: FirebaseAuth.instance);
    }

);
class SearchRepository{
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  SearchRepository(
      {
        required this.fire,
        required this.auth
      });

  Stream<QuerySnapshot>search(String uid){

  return fire.collection('users')
        .doc(uid).collection('c')
        .snapshots();


  }
}
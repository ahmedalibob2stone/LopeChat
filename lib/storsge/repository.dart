



import 'dart:io';

import 'package:riverpod/riverpod.dart';

import 'package:firebase_storage/firebase_storage.dart';
final FirebaseStorageRepositoryProvider=Provider((ref) =>
FirebaseStorageRepository(firebasestorage: FirebaseStorage.instance)
);
class FirebaseStorageRepository{
  final FirebaseStorage firebasestorage;

  FirebaseStorageRepository({
    required this.firebasestorage
});
  Future<String>storeFiletofirstorage(String ref,File file)async{

    UploadTask uploadTask = firebasestorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
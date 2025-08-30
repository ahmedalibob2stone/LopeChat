import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';

PickImage(ImageSource source)async{
  final ImagePicker _ImagePicker=ImagePicker();

  XFile? _file=await _ImagePicker.pickImage(source: source);
  if(_file !=null){
    return await _file.readAsBytes();
  }
  else{
    print("no Image selected");
  }
}
Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
    await ImagePicker().pickImage(source:ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    ShowSnakBar(context: context, content: e.toString());
  }
  return image;
}
Future<File?> tackImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
    await ImagePicker().pickImage(source:ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    ShowSnakBar(context: context, content: e.toString());
  }
  return image;
}

void ShowSnakBar({ required String content,required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:Text(content),
    ));


}
Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? Vidoe;
  try {
    final pickedVideo =
    await ImagePicker().pickVideo(source:ImageSource.gallery);

    if (pickedVideo != null) {
      Vidoe = File(pickedVideo.path);
    }
  } catch (e) {
    ShowSnakBar(context: context, content: e.toString());
  }
  return Vidoe;
}



Future<GiphyGif?> PickGif(BuildContext context) async {
  try {
    final gif = await GiphyGet.getGif(
      context: context,
      apiKey: 'UuTDSoXi6i1aRcD17AQOb67pjT9bu623',
      lang: GiphyLanguage.english,
    );
    return gif;
  } catch (e) {
    ShowSnakBar(context: context, content: 'حدث خطأ أثناء اختيار GIF: $e');
    return null;
  }
}




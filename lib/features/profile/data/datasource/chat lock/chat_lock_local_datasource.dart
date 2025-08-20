import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatLockLocalDataSource {

  ChatLockLocalDataSource();

  Future<void> lockChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chat_locked_$chatId', true);
  }

  Future<void> unlockChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chat_locked_$chatId', false);
  }

  Future<bool> isChatLocked(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('chat_locked_$chatId') ?? false;
  }

}

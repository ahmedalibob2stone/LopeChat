import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../../storsge/repository.dart';
import '../../../group/data/model/group/group.dart';
import '../../../user/data/user_model/user_model.dart';
import '../model/contact/chat_contact.dart';
import '../model/massage/massage_model.dart';

class ChatMessageRemoteDataSource {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final FirebaseStorageRepository storage;

  ChatMessageRemoteDataSource({required this.fire, required this.auth, required this.storage});

  //==================== إرسال الرسائل النصية ====================//
  Future<void> sendTextMessage({
    required String text,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {

      final messageId = const Uuid().v1();
      final time = DateTime.now();

      UserModel? reciveUserData;
      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(reciveUserId).get();

        // ✅ ضع الكود للتحقق هنا
        print("📄 المستند من Firestore: ${userdata.data()}");

        if (userdata.exists) {
          final data = userdata.data();
          if (data != null) {
            reciveUserData = UserModel.fromMap(data);
            print("✅ تم إنشاء UserModel بنجاح: ${reciveUserData.name}");
          } else {
            print("⚠️ المستند موجود لكن البيانات فارغة!");
            return; // تمنع الإرسال إذا البيانات فارغة
          }
        } else {
          print("⚠️ المستند غير موجود على الإطلاق!");
          return; // تمنع الإرسال إذا المستند غير موجود
        }

        // 🔹 حالة إرسال رسالة لنفسك
        if (reciveUserId == sendUser.uid) {
          reciveUserData = sendUser; // استخدم بياناتك مباشرة
          print("🟢 إرسال رسالة لنفسك، استخدم بيانات المستخدم الحالي مباشرة");
        }
      }



      await _saveDatatoContact(
        senderUserData: sendUser,
        reciverUserData: reciveUserData,
        text: text,
        time: time,
        chatId: reciveUserId,
        isGroupChat: isGroupChat,
      );

      await _saveMessageInSubcollection(
        chatId: reciveUserId,
        text: text,
        time: time,
        messageId: messageId,
        username: sendUser.name,
        EnumMassageType: EnumData.text,
        prof: sendUser.profile,
        proff: reciveUserData?.profile,
        messageReply: messageReply,
        SenderUserName: sendUser.name,
        ReciveUserName: reciveUserData?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e,st) {
      print("❌ Error in sendTextMessage: $e");
      print(st);
    }
    await Future.wait([

    ]);
  }

  //==================== إرسال الملفات (صور، فيديو، صوت...) ====================//
  Future<String> sendFileMessage({
    required File file,
    required String reciveUserId,
    required UserModel senderUserData,
    required EnumData massageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();

      final fileUrl = await storage.storeFiletofirstorage(
        'chat/${massageEnum.type}/${senderUserData.uid}/$reciveUserId/$messageId',
        file,
      );

      UserModel? reciverUserData;
      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(reciveUserId).get();
        if (userdata.exists && userdata.data() != null) {
          reciverUserData = UserModel.fromMap(userdata.data()!);
        } else {
          print("⚠️ المستقبل غير موجود في users: $reciveUserId");
        }
        if (reciveUserId == senderUserData.uid) {
          reciverUserData = senderUserData;
          print("🟢 إرسال رسالة لنفسك، استخدم بيانات المستخدم الحالي مباشرة");
        }
      }

      final contactMsg = massageEnum == EnumData.text
          ? file.path.split('/').last
          : getContactMessageText(massageEnum);

      await _saveDatatoContact(
        senderUserData: senderUserData,
        reciverUserData: reciverUserData,
        text: contactMsg,
        time: timeSent,
        chatId: reciveUserId,
        isGroupChat: isGroupChat,
      );

      await _saveMessageInSubcollection(
        chatId: reciveUserId,
        text: fileUrl,
        time: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        EnumMassageType: massageEnum,
        prof: senderUserData.profile,
        proff: reciverUserData?.profile,
        messageReply: messageReply,
        SenderUserName: senderUserData.name,
        ReciveUserName: reciverUserData?.name,
        isGroupChat: isGroupChat,
      );

      return messageId; // ✅ هكذا تعيد الـ messageId
    } catch (e, st) {
      print("❌ Error in sendFileMessage: $e");
      print(st);
      rethrow; // أو return ''; إذا أردت قيمة افتراضية عند الخطأ
    }
  }


  //==================== إرسال GIF ====================//
  Future<void> sendGIFMessage({
    required String gif,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final time = DateTime.now();

      UserModel? reciveUserData;
      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(reciveUserId).get();
        if (userdata.exists && userdata.data() != null) {
          reciveUserData = UserModel.fromMap(userdata.data()!);
        } else {
          print("⚠️ المستقبل غير موجود في users: $reciveUserId");
          // ممكن ترجع أو تكمل بدون futureUserData
          return;
        }
        if (reciveUserId == sendUser.uid) {
          reciveUserData = sendUser; // استخدم بياناتك مباشرة
          print("🟢 إرسال رسالة لنفسك، استخدم بيانات المستخدم الحالي مباشرة");
        }

      }

      await _saveDatatoContact(
        senderUserData: sendUser,
        reciverUserData: reciveUserData,
        text: 'GIF',
        time: time,
        chatId: reciveUserId,
        isGroupChat: isGroupChat,
      );

      await _saveMessageInSubcollection(
        chatId: reciveUserId,
        text: gif,
        time: time,
        messageId: messageId,
        username: sendUser.name,
        EnumMassageType: EnumData.gif,
        prof: sendUser.profile,
        proff: reciveUserData?.profile,
        messageReply: messageReply,
        SenderUserName: sendUser.name,
        ReciveUserName: reciveUserData?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e,st) {
      print("❌ Error in sendGIFMessage: $e");
      print(st);
    }
  }

  //==================== حفظ بيانات المراسلة ====================//
  Future<void> _saveDatatoContact({
    required UserModel senderUserData,
    required UserModel? reciverUserData,
    required String text,
    required DateTime time,
    required String chatId,
    required bool isGroupChat,
  }) async {
    try {
      if (isGroupChat) {
        final groupDoc = fire.collection('groups').doc(chatId);
        final groupSnapshot = await groupDoc.get();
        final groupData = GroupModel.fromMap(groupSnapshot.data()!);

        final updatedUnreadCounts = Map<String, int>.from(groupData.unreadMessageCount);
        for (var uid in groupData.membersUid) {
          if (uid != auth.currentUser!.uid) {
            updatedUnreadCounts[uid] = (updatedUnreadCounts[uid] ?? 0) + 1;
          }
        }

        await groupDoc.update({
          'lastMessage': text,
          'timeSent': time.millisecondsSinceEpoch,
          'unreadMessageCount': updatedUnreadCounts,
        });
      } else {
        final receiverChatDoc = await fire.collection('users')
            .doc(reciverUserData!.uid)
            .collection('chats')
            .doc(auth.currentUser!.uid)
            .get();

        final unreadMessageCount = receiverChatDoc.exists
            ? (receiverChatDoc.data()?['unreadMessageCount'] ?? 0) + 1
            : 1;

        final receiver = ChatContactModel(
          name: senderUserData.name,
          prof: senderUserData.profile,
          contactId: senderUserData.uid,
          time: time,
          isOnline: senderUserData.isOnline,
          unreadMessageCount: unreadMessageCount,
          isSeen: false,
          lastMessage: text,
          receiverId: reciverUserData.uid,
          isArchived: false,
        );

        final sender = ChatContactModel(
          name: reciverUserData.name,
          prof: reciverUserData.profile,
          contactId: reciverUserData.uid,
          time: time,
          isOnline: reciverUserData.isOnline,
          unreadMessageCount: 0,
          isSeen: false,
          lastMessage: text,
          receiverId: reciverUserData.uid,
          isArchived: false,
        );

        await fire.collection('users').doc(reciverUserData.uid)
            .collection('chats')
            .doc(auth.currentUser!.uid)
            .set(receiver.toMap());

        await fire.collection('users').doc(auth.currentUser!.uid)
            .collection('chats')
            .doc(reciverUserData.uid)
            .set(sender.toMap());
      }
    } catch (e) {
      print("Error in _saveDatatoContact: $e");
    }
  }

  //==================== حفظ الرسائل في Subcollection ====================//
  Future<void> _saveMessageInSubcollection({
    required String chatId,
    required String text,
    required DateTime time,
    required String messageId,
    required String username,
    required EnumData EnumMassageType,
    required String prof,
    required String? proff,
    required MessageReply? messageReply,
    required String SenderUserName,
    required String? ReciveUserName,
    required bool isGroupChat,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      chatId: chatId,
      text: text,
      time: time,
      type: EnumMassageType,
      messageId: messageId,
      isSeen: false,
      prof: prof,
      proff: proff ?? '',
      repliedMessage: messageReply?.message ?? '',
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
          ? SenderUserName
          : ReciveUserName ?? '',
      repliedMessageType: messageReply?.messageDate ?? EnumData.text,
    );

    if (isGroupChat) {
      await fire.collection('groups').doc(chatId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      await fire.collection('users').doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await fire.collection('users').doc(chatId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  //==================== استرجاع الرسائل الفردية ====================//
  Stream<List<MessageModel>> getStreamMessages(String reciveUserId) {
    return fire.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciveUserId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());
  }

  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    return fire.collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('time')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());
  }
  Future<void> updateUserStatus(bool isOnline) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final userDoc = fire.collection('users').doc(uid);

    await userDoc.set({
      'isOnline': isOnline ? 'online' : 'offline', // هنا نحول Boolean → String
      'lastSeen': isOnline ? null : DateTime.now().toUtc().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> setChatMessageSeen({
    required String reciveUserId,
    required String messageId,
  }) async {
    try {
      await fire.collection('users').doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciveUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await fire.collection('users').doc(reciveUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      print('Error in setChatMessageSeen: $e');
    }
  }
  Future<void> markMessagesAsSeen(String reciveUserId) async {
    try {
      final userChatDoc = fire
          .collection('users')
          .doc(reciveUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid);

      final messagesQuery = await userChatDoc
          .collection('messages')
          .where('isSeen', isEqualTo: false)
          .get();

      final batch = fire.batch();

      for (var doc in messagesQuery.docs) {
        batch.update(doc.reference, {'isSeen': true});
      }

      batch.update(userChatDoc, {
        'unreadMessageCount': 0,
        'isSeen': true,
      });

      await batch.commit();
    } catch (e) {
      print('Error in markMessagesAsSeen: $e');
    }
  }
  Future<void> sendLinkMessage({
    required String link,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final time = DateTime.now();

      UserModel? reciveUserData;
      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(reciveUserId).get();
        if (userdata.exists && userdata.data() != null) {
          reciveUserData = UserModel.fromMap(userdata.data()!);
        } else {
          print("⚠️ المستقبل غير موجود في users: $reciveUserId");
          // ممكن ترجع أو تكمل بدون futureUserData
          return;
        }
        if (reciveUserId == sendUser.uid) {
          reciveUserData = sendUser; // استخدم بياناتك مباشرة
          print("🟢 إرسال رسالة لنفسك، استخدم بيانات المستخدم الحالي مباشرة");
        }

      }

      await _saveDatatoContact(
        senderUserData: sendUser,
        reciverUserData: reciveUserData,
        text: '🔗 Link',
        time: time,
        chatId: reciveUserId,
        isGroupChat: isGroupChat,
      );

      await _saveMessageInSubcollection(
        chatId: reciveUserId,
        text: link,
        time: time,
        messageId: messageId,
        username: sendUser.name,
        EnumMassageType: EnumData.link,
        prof: sendUser.profile,
        proff: reciveUserData?.profile,
        messageReply: messageReply,
        SenderUserName: sendUser.name,
        ReciveUserName: reciveUserData?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e,st) {
      print("❌ Error in sendLinkMessage: $e");
      print(st);
    }
  }

  Future<void> deleteMessage({
    required String reciveUserId,    required String messageId,
  }) async {
    try {
      await fire.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciveUserId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e, stackTrace) {
      print('Error deleting message: $e');
      print(stackTrace);
    }
  }

}

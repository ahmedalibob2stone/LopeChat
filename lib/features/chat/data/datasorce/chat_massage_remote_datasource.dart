

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/enums/enum_massage.dart';

import '../../../../storsge/repository.dart';
import '../../../group/data/model/group/group.dart';
import '../../../settings/presentation/provider/privacy/advanced/vm/advanced_privacy_viewmodel_provider.dart';
import '../../../user/data/user_model/user_model.dart';

import '../model/contact/chat_contact.dart';
import '../model/massage/massage_model.dart';

class ChatMessageRemoteDataSource {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final Ref ref;

  ChatMessageRemoteDataSource({
    required this.fire,
    required this.auth,
    required this.ref,
  });

  Future<void> sendTextMessage({
    required String text,
    required String chatId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {

    try {
      final messageId = const Uuid().v1();
      final time = DateTime.now();
      UserModel? reciveUserData;

      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(chatId).get();
        reciveUserData = UserModel.fromMap(userdata.data()!);
      }

      await saveDatatoContact(
        senderUserData: sendUser,
        reciverUserData: reciveUserData,
        text: text,
        time: time,
        chatId: chatId,
        isGroupChat: isGroupChat,
      );

      await saveMessageInSubcollection(
        chatId: chatId,
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
    } catch (e, stackTrace) {
      print("Error sending message: $e");
      print(stackTrace);
    }
  }

  Future<void> sendGIFMessage({
    required String gif,
    required String chatId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final time = DateTime.now();

      UserModel? reciveUserData;

      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(chatId).get();
        reciveUserData = UserModel.fromMap(userdata.data()!);
      }

      await saveDatatoContact(
        senderUserData: sendUser,
        reciverUserData: reciveUserData,
        text: 'GIF',
        time: time,
        chatId: chatId,
        isGroupChat: isGroupChat,
      );

      await saveMessageInSubcollection(
        chatId: chatId,
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
    } catch (e, st) {
      print('⚠️ Error sending GIF message: $e');
      print('📍 StackTrace: $st');
    }
  }

  Future<void> sendFileMessage({
    required File file,
    required String chatId,
    required UserModel senderUserDate,
    required EnumData massageEnum,
    required MessageReply messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();


      final imageUrl = await ref.read(FirebaseStorageRepositoryProvider)
          .storeFiletofirstorage(
          'chat/${massageEnum.type}/${senderUserDate.uid}/$chatId/$messageId',
          file);

      UserModel? reciverUserDate;
      if (!isGroupChat) {
        final userdateDoc = await fire.collection('users').doc(chatId).get();
        if (userdateDoc.exists) {
          reciverUserDate = UserModel.fromMap(userdateDoc.data()!);
        }
      }

      String contactMsg;
      switch (massageEnum) {
        case EnumData.image:
          contactMsg = '📷 Photo';
          break;
        case EnumData.video:
          contactMsg = '📸 Video';
          break;
        case EnumData.audio:
          contactMsg = '🎵 Audio';
          break;
        case EnumData.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'File';
      }

      await saveDatatoContact(
        chatId: chatId,
        senderUserData: senderUserDate,
        reciverUserData: reciverUserDate,
        text: contactMsg,
        time: timeSent,
        isGroupChat: isGroupChat,
      );

      await saveMessageInSubcollection(
        chatId: chatId,
        text: imageUrl,
        time: timeSent,
        messageId: messageId,
        username: senderUserDate.name,
        EnumMassageType: massageEnum,
        prof: senderUserDate.profile,
        proff: reciverUserDate?.profile,
        messageReply: messageReply,
        SenderUserName: senderUserDate.name,
        ReciveUserName: reciverUserDate?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e, stackTrace) {
      print("❌ Error sending file message: $e");
      print(stackTrace);
    }
  }


  Stream<List<MessageModel>> getStreamMessages(String chatId) {
    final blockUnknown = ref
        .read(advancedPrivacyViewModelProvider)
        .blockUnknownMessages;

    return fire.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .asyncMap((snapshot) async {
      final allMessages = snapshot.docs.map((e) =>
          MessageModel.fromMap(e.data())).toList();

      if (!blockUnknown) return allMessages;

      // فلترة الرسائل بناءً على المرسل
      return Future.wait(allMessages.map((msg) async {
        final contactId = msg.senderId;
        if (contactId == auth.currentUser!.uid) return msg; // نفسك

        // التحقق من إذا المرسل موجود في قاعدة بيانات جهات الاتصال
        final contactDoc = await fire.collection('users')
            .doc(auth.currentUser!.uid)
            .collection('contacts') // أو حسب مكان قائمة المعارف
            .doc(contactId)
            .get();

        return contactDoc.exists ? msg : null;
      })).then((list) => list.whereType<MessageModel>().toList());
    });
  }


  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    return fire.collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('time')
        .snapshots()
        .map((event) =>
        event.docs.map((e) => MessageModel.fromMap(e.data())).toList());
  }


  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await fire.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e, stackTrace) {
      print('Error deleting message: $e');
      print(stackTrace);
    }
  }


  Future<void> setChatMessageSeen({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await fire.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await fire.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e, stackTrace) {
      print('Error in setChatMessageSeen: $e');
      print(stackTrace);
    }
  }


  Future<void> markMessagesAsSeen(String chatId, String contactId) async {
    try {
      final userChatDoc = fire
          .collection('users')
          .doc(contactId)
          .collection('chats')
          .doc(chatId);

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
    } catch (e, stackTrace) {
      print('Error in markMessagesAsSeen: $e');
      print(stackTrace);
    }
  }

  Future<void> saveDatatoContact({
    required UserModel senderUserData,
    required UserModel? reciverUserData,
    required String text,
    required DateTime time,
    required String chatId, // المعرف الجديد للمحادثة
    required bool isGroupChat,
  }) async {
    try {
      if (isGroupChat) {
        final groupDoc = fire.collection('groups').doc(
            chatId); // هنا chatId هو groupId
        final groupSnapshot = await groupDoc.get();
        final groupData = GroupModel.fromMap(groupSnapshot.data()!);

        final updatedUnreadCounts = Map<String, int>.from(
            groupData.unreadMessageCount);
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
            .doc(chatId)
            .get();

        final unreadMessageCount = receiverChatDoc.exists
            ? (receiverChatDoc.data()?['unreadMessageCount'] ?? 0) + 1
            : 1;

        final receiver = ChatContactModel(
          name: senderUserData.name,
          prof: senderUserData.profile,
          contactId: senderUserData.uid,
          time: time,
          lastMessage: text,
          isOnline: senderUserData.isOnline,
          unreadMessageCount: unreadMessageCount,
          receiverId: reciverUserData.uid,
          isSeen: false,
          isArchived: false,
        );

        await fire.collection('users')
            .doc(reciverUserData.uid)
            .collection('chats')
            .doc(chatId)
            .set(receiver.toMap());

        final sender = ChatContactModel(
          name: reciverUserData.name,
          prof: reciverUserData.profile,
          contactId: reciverUserData.uid,
          time: time,
          lastMessage: text,
          isOnline: reciverUserData.isOnline,
          unreadMessageCount: 0,
          receiverId: reciverUserData.uid,
          isSeen: false,
          isArchived: false,
        );

        await fire.collection('users')
            .doc(auth.currentUser!.uid)
            .collection('chats')
            .doc(chatId)
            .set(sender.toMap());
      }
    } catch (e, stackTrace) {
      print('Error in saveDatatoContact: $e');
      print(stackTrace);
    }
  }


  Future<void> saveMessageInSubcollection({
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
      // صححت هنا بدلاً من reciveUserId
      text: text,
      time: time,
      type: EnumMassageType,
      messageId: messageId,
      isSeen: false,
      prof: prof,
      proff: proff ?? '',
      // للتأكد من عدم تمرير null
      repliedMessage: messageReply?.message ?? '',
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
          ? SenderUserName
          : ReciveUserName ?? '',
      repliedMessageType: messageReply?.messageDate ?? EnumData.text,
    );

    if (isGroupChat) {
      await fire
          .collection('groups')
          .doc(chatId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      await fire
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  Future<void> updateUserStatus(bool isOnline) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

    if (isOnline) {
      await userDoc.update({
        'isOnline': 'online',
      });
    } else {
      await userDoc.update({
        'isOnline': 'offline',
        'lastSeen': DateTime.now().toIso8601String(),
        // تخزين الوقت الحالي كآخر ظهور
      });
    }
  }


  Future<void> sendLinkMessage({
    required String link,
    required String chatId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final time = DateTime.now();
      UserModel? reciveUserData;

      if (!isGroupChat) {
        final userdata = await fire.collection('users').doc(chatId).get();
        reciveUserData = UserModel.fromMap(userdata.data()!);
      }

      await saveDatatoContact(
        senderUserData: sendUser,
        reciverUserData: reciveUserData,
        text: '🔗 Link',
        time: time,
        chatId: chatId,
        isGroupChat: isGroupChat,
      );

      await saveMessageInSubcollection(
        chatId: chatId,
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
    } catch (e, st) {
      print('⚠️ Error sending link message: $e');
      print('📍 StackTrace: $st');
    }
  }
}




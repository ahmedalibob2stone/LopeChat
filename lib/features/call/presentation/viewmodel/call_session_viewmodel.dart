import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../domain/usecase/end_call_use_case.dart';

enum CallStatus { idle, loading, joined, disconnected, error }

class CallState {
  final CallStatus status;
  final int? remoteUid;
  final String? errorMessage;
  final bool isVideo;

  const CallState({
    this.status = CallStatus.idle,
    this.remoteUid,
    this.errorMessage,
    this.isVideo = false,
  });

  CallState copyWith({
    CallStatus? status,
    int? remoteUid,
    String? errorMessage,
    bool? isVideo,
  }) {
    return CallState(
      status: status ?? this.status,
      remoteUid: remoteUid ?? this.remoteUid,
      errorMessage: errorMessage ?? this.errorMessage,
      isVideo: isVideo ?? this.isVideo,
    );
  }
}

class CallSessionViewModel extends StateNotifier<CallState> {
  late RtcEngine engine;
  final EndCallUseCase endCallUseCase;

  CallSessionViewModel({required this.endCallUseCase}) : super(const CallState());

  Future<String> _fetchToken(String channelId, int uid) async {
    final url = Uri.parse('https://lopechat.onrender.com/agora/get-token?channelId=$channelId&uid=$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to fetch token: ${response.body}');
    }
  }

  Future<void> initCall({
    required String appId,
    required String channelId,
    required int uid,
    required bool isVideo,
    bool isGroupChat = false,
    String? groupId,
    bool relay = false,
  }) async {
    try {
      state = state.copyWith(status: CallStatus.loading, isVideo: isVideo);

      if (isVideo) {
        await [Permission.microphone, Permission.camera].request();
      } else {
        await [Permission.microphone].request();
      }

      // إنشاء المحرك
      engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(appId: appId));

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            state = state.copyWith(status: CallStatus.joined);
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            state = state.copyWith(remoteUid: remoteUid);
          },
          onUserOffline: (connection, remoteUid, reason) {
            state = state.copyWith(remoteUid: null);
          },
          onLeaveChannel: (connection, stats) {
            state = state.copyWith(status: CallStatus.disconnected);
          },
          onError: (errorCode, msg) {
            state = state.copyWith(
              status: CallStatus.error,
              errorMessage: 'Error $errorCode: $msg',
            );
          },
        ),
      );

      // تعيين نوع البروكسي
      await engine.setCloudProxy(relay ? CloudProxyType.udpProxy : CloudProxyType.noneProxy);

      // تمكين الفيديو أو الصوت
      if (isVideo) {
        await engine.enableVideo();
        await engine.startPreview();
      } else {
        await engine.enableAudio();
      }

      final token = await _fetchToken(channelId, uid);

      if (isGroupChat && groupId != null) {
        // تنفيذ المكالمات الجماعية لكل أعضاء المجموعة
        final groupSnap = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
        if (groupSnap.exists && groupSnap.data() != null) {
          final members = List<String>.from(groupSnap.data()!['membersUid']);
          for (var memberId in members) {
            // إنشاء قناة لكل عضو أو انضمام جماعي
            await engine.joinChannel(
              token: token,
              channelId: '$channelId-$memberId',
              uid: uid,
              options: const ChannelMediaOptions(),
            );
          }
        } else {
          throw Exception('Group data not found for id: $groupId');
        }
      } else {
        // مكالمة فردية
        await engine.joinChannel(
          token: token,
          channelId: channelId,
          uid: uid,
          options: const ChannelMediaOptions(),
        );
      }
    } catch (e) {
      state = state.copyWith(status: CallStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> leaveCall({String? callerId, String? receiverId}) async {
    try {
      await engine.leaveChannel();
      await engine.release();
      if (callerId != null && receiverId != null) {
        await endCallUseCase.call(callerId, receiverId);
      }
      state = state.copyWith(status: CallStatus.disconnected, remoteUid: null);
    } catch (e) {
      state = state.copyWith(status: CallStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> endCall(String callerId, String receiverId) async{
    try{
      await endCallUseCase.call(callerId, receiverId);
    }catch(e){
      state = state.copyWith(status: CallStatus.error, errorMessage: e.toString());

    }


  }

  int? get remoteUid => state.remoteUid;
}

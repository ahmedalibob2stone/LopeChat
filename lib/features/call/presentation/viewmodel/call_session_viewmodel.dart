import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;

import '../../domain/usecase/end_call_use_case.dart';


enum CallStatus { initial, loading, joined, disconnected, error }

class CallState {
  final CallStatus status;
  final int? remoteUid;
  final String? errorMessage;

  CallState({
    this.status = CallStatus.initial,
    this.remoteUid,
    this.errorMessage,
  });

  CallState copyWith({
    CallStatus? status,
    int? remoteUid,
    String? errorMessage,
  }) {
    return CallState(
      status: status ?? this.status,
      remoteUid: remoteUid ?? this.remoteUid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CallSessionViewModel extends StateNotifier<CallState> {
  late RtcEngine engine;
  final EndCallUseCase endCallUseCase;

  CallSessionViewModel({required this.endCallUseCase}) : super(CallState());

  Future<String> _fetchToken(String channelId, int uid) async {
    // إذا شغال محلي على محاكي Android استخدم 10.0.2.2 بدل localhost
    // إذا جهاز حقيقي، ضع الـ IP للسيرفر (مثلاً: 192.168.1.10)
    final url = Uri.parse('http://localhost:3000/agora/get-token?channelId=$channelId&uid=$uid');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to fetch token: ${response.body}');
    }
  }


  Future<void> initCall(String appId, String channelId, int uid, {
    bool relay = false,
  }) async {

    try {

      state = state.copyWith(status: CallStatus.loading);

      await [Permission.microphone, Permission.camera].request();

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
      if (relay) {
        await engine.setCloudProxy(CloudProxyType.udpProxy);
      } else {
        await engine.setCloudProxy(CloudProxyType.noneProxy);
      }
      await engine.enableVideo();
      await engine.startPreview();

      final token = await _fetchToken(channelId, uid);

      await engine.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      state = state.copyWith(status: CallStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> leaveCall(String callerId, String receiverId, BuildContext context) async {
    await engine.leaveChannel();
    await engine.release();
    await endCallUseCase.call(callerId, receiverId);
    state = state.copyWith(status: CallStatus.disconnected, remoteUid: null);
  }

  Future<void> endCall(String callerId, String receiverId) async {
    await endCallUseCase.call(callerId, receiverId);
  }

  int? get remoteUid => state.remoteUid;
}

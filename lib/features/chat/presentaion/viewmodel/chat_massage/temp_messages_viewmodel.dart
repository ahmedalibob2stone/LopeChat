import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/enums/enum_massage.dart';

class TempMessage {
  final String id;
  final File? file;
  final EnumData type;
  final DateTime time;
  final double progress; // نسبة رفع الملف
  final bool isUploaded; // انتهى رفع الملف إلى Firebase Storage
  final bool isSentToServer; // النسخة النهائية وصلت Firestore
  final String? serverMessageId;

  TempMessage({
    required this.id,
    this.file,
    required this.type,
    required this.time,
    this.progress = 0.0,
    this.isUploaded = false,
    this.isSentToServer = false,
    this.serverMessageId,
  });

  TempMessage copyWith({
    String? id,
    File? file,
    EnumData? type,
    DateTime? time,
    double? progress,
    bool? isUploaded,
    bool? isSentToServer,
    String? serverMessageId,
  }) {
    return TempMessage(
      id: id ?? this.id,
      file: file ?? this.file,
      type: type ?? this.type,
      time: time ?? this.time,
      progress: progress ?? this.progress,
      isUploaded: isUploaded ?? this.isUploaded,
      isSentToServer: isSentToServer ?? this.isSentToServer,
      serverMessageId: serverMessageId ?? this.serverMessageId,
    );
  }

  bool get showProgress => !isSentToServer; // للتحكم في UI
  double? get progressValue => isUploaded ? null : progress; // null = شريط انتظار
}


class TempMessageNotifier extends StateNotifier<List<TempMessage>> {
  TempMessageNotifier() : super([]);

  void addTempMessage(TempMessage message) {
    state = [...state, message];
  }

  void updateProgress(String tempId, double progress) {
    state = state.map((msg) {
      if (msg.id == tempId) {
        return msg.copyWith(progress: progress);
      }
      return msg;
    }).toList();
  }

  void markUploadComplete(String tempId) {
    state = state.map((msg) {
      if (msg.id == tempId) {
        return msg.copyWith(isUploaded: true, progress: 1.0);
      }
      return msg;
    }).toList();
  }

  void markAsSent(String tempId, String serverMessageId) {
    state = state.map((msg) {
      if (msg.id == tempId) {
        return msg.copyWith(
          isSentToServer: true,
          serverMessageId: serverMessageId,
        );
      }
      return msg;
    }).toList();
  }

  void replaceWithServerMessage(String serverMessageId) {
    state = [
      for (final msg in state)
        if (msg.serverMessageId != serverMessageId) msg,
    ];
  }


  void removeTempMessage(String tempId) {
    state = state.where((msg) => msg.id != tempId).toList();
  }
}

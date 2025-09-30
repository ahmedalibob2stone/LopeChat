  import 'dart:io';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import '../../../../../common/enums/enum_massage.dart';

  class TempMessage {
    final String id;
    final File? file; // الملف المحلي أثناء التحميل
    final String text; // 🟢 أضف النص
    final String gifUrl;
    final String link;
    final String? uploadedUrl; // الرابط النهائي بعد الرفع
    final EnumData type;
    final DateTime time;
    final double progress; // نسبة رفع الملف
    final bool isUploaded; // انتهى رفع الملف إلى Firebase Storage
    final bool isSentToServer; // النسخة النهائية وصلت Firestore
    final String? serverMessageId;

    TempMessage({
      required this.id,
      this.file,
      this.uploadedUrl,
      required this.type,
      required this.text,
      required this.link,
      required this.gifUrl,
      required this.time,
      this.progress = 0.0,
      this.isUploaded = false,
      this.isSentToServer = false,
      this.serverMessageId,
    });

    TempMessage copyWith({
      String? id,
      File? file,
      String? uploadedUrl,
      EnumData? type,
      DateTime? time,
      double? progress,
      bool? isUploaded,
      bool? isSentToServer,
      String? serverMessageId,
      String? text,
      String? gifUrl,
      String? link
    }) {
      return TempMessage(
        id: id ?? this.id,
        file: file ?? this.file,
        uploadedUrl: uploadedUrl ?? this.uploadedUrl,
        type: type ?? this.type,
        time: time ?? this.time,
        progress: progress ?? this.progress,
        isUploaded: isUploaded ?? this.isUploaded,
        text: text ?? this.text,
        gifUrl: gifUrl ?? this.gifUrl,
        link: link ?? this.link,
        isSentToServer: isSentToServer ?? this.isSentToServer,
        serverMessageId: serverMessageId ?? this.serverMessageId,
      );
    }

    bool get showProgress => type != EnumData.text && !isSentToServer;

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
      state = state.map((msg) {
        if (msg.serverMessageId == serverMessageId) {
          // علامة أنها أصبحت رسالًة من السيرفر، بدون حذفها
          return msg.copyWith(isSentToServer: true);
        }
        return msg;
      }).toList();
    }

    void updateFile(String tempId, {File? file, String? uploadedUrl}) {
      state = state.map((msg) {
        if (msg.id == tempId) {
          return msg.copyWith(
            file: file ?? msg.file,
            uploadedUrl: uploadedUrl ?? msg.uploadedUrl,
          );
        }
        return msg;
      }).toList();
    }

    void removeTempMessage(String tempId) {
      state = state.where((msg) => msg.id != tempId).toList();
    }
  }

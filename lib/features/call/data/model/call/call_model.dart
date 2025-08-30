import '../../../domain/entites/callentites.dart';

class CallModel {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;
  final DateTime timestamp;
  final  bool isVideo;
  CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialled,
    required this.timestamp,
    required this.isVideo,
  });

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPic: map['receiverPic'] ?? '',
      callId: map['callId'] ?? '',
      hasDialled: map['hasDialled'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
       isVideo:map['isVideo'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialled': hasDialled,
      'timestamp': timestamp.millisecondsSinceEpoch,
       'isVideo':isVideo,
    };
  }

  /// للتحويل من الـ Entity
  factory CallModel.fromEntity(CallEntites entity) {
    return CallModel(
      callerId: entity.callerId,
      callerName: entity.callerName,
      callerPic: entity.callerPic,
      receiverId: entity.receiverId,
      receiverName: entity.receiverName,
      receiverPic: entity.receiverPic,
      callId: entity.callId,
      hasDialled: entity.hasDialled,
      timestamp: entity.timestamp,
      isVideo:entity.isVideo
    );
  }

  /// للتحويل إلى الـ Entity
  CallEntites toEntity() {
    return CallEntites(
      callerId: callerId,
      callerName: callerName,
      callerPic: callerPic,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPic: receiverPic,
      callId: callId,
      hasDialled: hasDialled,
      timestamp: timestamp,
      isVideo:isVideo,
    );
  }
}

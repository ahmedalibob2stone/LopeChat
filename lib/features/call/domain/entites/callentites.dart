// usecase/entities/callentites.dart

class CallEntites {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;
  final DateTime timestamp;
  final bool isVideo;

  CallEntites({
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
  CallEntites copyWith({
    String? callerId,
    String? callerName,
    String? callerPic,
    String? receiverId,
    String? receiverName,
    String? receiverPic,
    String? callId,
    bool? hasDialled,
    DateTime? timestamp,
    bool? isVideo,
  }) {
    return CallEntites(
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerPic: callerPic ?? this.callerPic,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverPic: receiverPic ?? this.receiverPic,
      callId: callId ?? this.callId,
      hasDialled: hasDialled ?? this.hasDialled,
      timestamp: timestamp ?? this.timestamp,
      isVideo: isVideo ?? this.isVideo,
    );
  }
}

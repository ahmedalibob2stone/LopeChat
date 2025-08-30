
import '../../../../domain/entities/privacy/calls/privacy_calls_entity.dart';

class PrivacyCallsModel extends PrivacyCallsEntity {
  const PrivacyCallsModel({
    required super.silenceUnknownCallers,
  });

  factory PrivacyCallsModel.fromMap(Map<String, dynamic> map) {
    return PrivacyCallsModel(
      silenceUnknownCallers: map['silenceUnknownCallers'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'silenceUnknownCallers': silenceUnknownCallers,
    };
  }
}

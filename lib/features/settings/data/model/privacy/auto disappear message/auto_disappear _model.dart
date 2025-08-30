import '../../../../domain/entities/privacy/auto disappear message/auto_disappear_entity.dart';

class DefaultDisappearModel extends DefaultDisappearEntity {
  const DefaultDisappearModel({
    required super.timer,
  });

  factory DefaultDisappearModel.fromMap(Map<String, dynamic> map) {
    return DefaultDisappearModel(
      timer: map['defaultDisappearTimer'] ?? 'off',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultDisappearTimer': timer,
    };
  }
}

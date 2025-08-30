

import '../../../../domain/entities/privacy/read_receipts/read_receipts_entity.dart';

class ReadReceiptsModel extends ReadReceiptsEntity {
  const ReadReceiptsModel({required super.readReceiptsEnabled});

  factory ReadReceiptsModel.fromMap(Map<String, dynamic> map) {
    return ReadReceiptsModel(
      readReceiptsEnabled: map['readReceiptsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'readReceiptsEnabled': readReceiptsEnabled,
    };
  }
}

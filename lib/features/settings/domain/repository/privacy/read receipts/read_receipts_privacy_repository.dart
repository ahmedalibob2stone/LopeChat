

import '../../../entities/privacy/read_receipts/read_receipts_entity.dart';

abstract class ReadReceiptsRepository {
  Future<ReadReceiptsEntity> getReadReceipts(String uid);
  Future<void> updateReadReceipts(String uid, bool enabled);
}



import '../../../model/privacy/read_receipts/read_receipts_model.dart';

abstract class ReadReceiptsRemoteDatasource {
  Future<ReadReceiptsModel> getReadReceipts(String uid);
  Future<void> updateReadReceipts(String uid, bool enabled);
}

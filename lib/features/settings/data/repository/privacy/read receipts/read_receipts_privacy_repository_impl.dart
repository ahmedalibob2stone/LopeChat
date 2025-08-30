
import '../../../../domain/entities/privacy/read_receipts/read_receipts_entity.dart';
import '../../../../domain/repository/privacy/read receipts/read_receipts_privacy_repository.dart';
import '../../../datasource/privacy/read receipts/read_receipts_privacy_remote_datasource.dart';

class ReadReceiptsRepositoryImpl implements ReadReceiptsRepository {
  final ReadReceiptsRemoteDatasource remoteDatasource;

  ReadReceiptsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ReadReceiptsEntity> getReadReceipts(String uid) async {
    final model = await remoteDatasource.getReadReceipts(uid);
    return model;
  }

  @override
  Future<void> updateReadReceipts(String uid, bool enabled) async {
    await remoteDatasource.updateReadReceipts(uid, enabled);
  }
}

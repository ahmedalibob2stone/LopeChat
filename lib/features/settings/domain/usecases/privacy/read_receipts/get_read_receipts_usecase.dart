
import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/read_receipts/read_receipts_entity.dart';
import '../../../repository/privacy/read receipts/read_receipts_privacy_repository.dart';

class GetReadReceiptsUseCase {
  final ReadReceiptsRepository repository;
  final FirebaseAuth auth;

  GetReadReceiptsUseCase({required this.repository, required this.auth});

  Future<ReadReceiptsEntity> call() async {
    final uid = auth.currentUser!.uid;
    return repository.getReadReceipts(uid);
  }
}

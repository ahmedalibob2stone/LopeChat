
import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/privacy/read receipts/read_receipts_privacy_repository.dart';

class UpdateReadReceiptsUseCase {
  final ReadReceiptsRepository repository;
  final FirebaseAuth auth;

  UpdateReadReceiptsUseCase({required this.repository, required this.auth});

  Future<void> call(bool enabled) async {
    final uid = auth.currentUser!.uid;
    await repository.updateReadReceipts(uid, enabled);
  }
}

import 'package:lopechat/features/settings/data/datasource/privacy/read%20receipts/read_receipts_privacy_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/privacy/read_receipts/read_receipts_model.dart';

class ReadReceiptsRemoteDatasourceImpl implements ReadReceiptsRemoteDatasource {
  final FirebaseFirestore firestore;

  ReadReceiptsRemoteDatasourceImpl({required this.firestore});

  @override
  Future<void> updateReadReceipts(String uid, bool enabled) async {
    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'read_receipts': {
          'readReceiptsEnabled': enabled,
        }
      }
    }, SetOptions(merge: true)); // نستخدم merge لعدم حذف باقي البيانات
  }

  @override
  Future<ReadReceiptsModel> getReadReceipts(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      return const ReadReceiptsModel(readReceiptsEnabled: true);
    }

    final data = doc.data();
    final readReceiptsEnabled = data?['privacy']?['readReceiptsEnabled']?['enabled'] ?? true;

    return ReadReceiptsModel(readReceiptsEnabled: readReceiptsEnabled);
  }
}

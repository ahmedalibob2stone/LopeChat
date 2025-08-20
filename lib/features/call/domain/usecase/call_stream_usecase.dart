
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repository/call_repository.dart';

class CallStreamUsecase {
  final CallRepository repository;

  CallStreamUsecase(this.repository);

  Stream<DocumentSnapshot> get callStream => repository.callStream;

}

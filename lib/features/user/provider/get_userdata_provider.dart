import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/user_repository.dart';
import '../domain/entities/user_entity.dart';
import '../model/user_model/user_model.dart';

final userStreamProvider = StreamProvider<UserEntity?>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.myData();  // Stream<UserEntity?> مباشرة
});




import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/data/user_model/user_model.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../user/presentation/provider/usecases/get_my_data_stream_usecase_provider.dart';

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final userStream = ref.watch(currentUserStreamProvider.stream);
  return userStream.map((userEntity) =>
  userEntity != null ? UserModel.fromEntity(userEntity) : null
  );
});

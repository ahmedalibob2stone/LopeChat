
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../viewmodel/ckeck_user_viewmodel.dart';
import '../usecases/get_my_data_stream_usecase_provider.dart';
import '../usecases/get_user_by_id_usecase_provider.dart';


final checkUserViewModelProvider =
StateNotifierProvider<CheckUserViewModel, CheckUserState>((ref) {
  final useCase = ref.read(getMyDataStreamUseCaseProvider);
  return CheckUserViewModel(useCase);
});

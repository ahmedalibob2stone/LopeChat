
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/ckeck_user_viewmodel.dart';

import '../domain/usecases/provider/get_my_DataStream_provider.dart';


final checkUserViewModelProvider =
StateNotifierProvider<CheckUserViewModel, CheckUserState>((ref) {
  final useCase = ref.read(getMyDataStreamUseCaseProvider);
  return CheckUserViewModel(useCase);
});

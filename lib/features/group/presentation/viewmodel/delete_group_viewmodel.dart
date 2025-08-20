import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/delete_group_usecase.dart';

class DeleteGroupViewModel extends StateNotifier<AsyncValue<void>> {
  final DeleteGroupUseCase deleteGroupUseCase;

  DeleteGroupViewModel(this.deleteGroupUseCase) : super(const AsyncData(null));

  Future<void> deleteGroup(String groupId) async {
    state = const AsyncLoading();
    try {
      await deleteGroupUseCase.execute(groupId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

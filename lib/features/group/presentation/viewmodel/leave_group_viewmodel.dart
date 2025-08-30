
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/leave_group_usecase.dart';

class LeaveGroupViewModel extends StateNotifier<bool> {
  final LeaveGroupUseCase useCase;

  LeaveGroupViewModel(this.useCase) : super(false);

  Future<void> leaveGroup(String groupId) async {
    state = true;
    try {
      await useCase.execute(groupId);
    } catch (e) {
      // يمكنك إضافة منطق الخطأ هنا
    } finally {
      state = false;
    }
  }
}

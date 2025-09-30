  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../../viewmodel/mark_status_as_seen_viewmodel.dart';
  import '../usecases/mark_status_as_seen_usecase.provider.dart';

  /// مزود ViewModel لإدارة حالة مشاهدة الـ Status
  final mark = StateNotifierProvider<StatusViewModel, StatusViewModelState>(
        (ref) {
      final useCase = ref.read(markStatusAsSeenUseCaseProvider); // use case من الريبو
      return StatusViewModel(markStatusAsSeenUseCase: useCase);
    },
  );

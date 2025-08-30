import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/report/report_entities.dart';
import '../../provider/report/usecases/provider.dart';

  final myReportsProvider = FutureProvider.autoDispose<List<ReportEntity>>((ref) async {
  final getMyReportsUseCase = ref.read(getMyReportsUseCaseProvider);
  return await getMyReportsUseCase.call();
});

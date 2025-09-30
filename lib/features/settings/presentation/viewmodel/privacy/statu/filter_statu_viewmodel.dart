import 'dart:async';

import 'package:lopechat/features/settings/presentation/viewmodel/privacy/statu/status_privacy_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../status/domain/entities/status_entity.dart';
import '../../../../../status/domain/usecases/get_statuses_usecase.dart';


class StatusState {
  final bool isLoading;
  final List<StatusEntity> statuses;
  final String? error;

  StatusState._({required this.isLoading, required this.statuses, this.error});

  factory StatusState.loading() => StatusState._(isLoading: true, statuses: []);

  factory StatusState.data(List<StatusEntity> statuses) =>
      StatusState._(isLoading: false, statuses: statuses);

  factory StatusState.error(String error) =>
      StatusState._(isLoading: false, statuses: [], error: error);
}

class FilterStatuViewmodel extends StateNotifier<StatusState> {
  final Ref ref;
  final StatusPrivacyState privacyState;
  final GetStatusesUseCase getStatusesUseCase;
  bool _isDisposed = false; // <-- علمنا إذا تم dispose
  List<StatusEntity> allStatuses = [];
  late final StreamSubscription<List<StatusEntity>> _subscription;

  FilterStatuViewmodel(this.ref, this.privacyState, this.getStatusesUseCase)
      : super(StatusState.loading()) {
    Future.microtask(() => _loadStatuses());
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadStatuses() async {
    _subscription = getStatusesUseCase().listen(
          (statuses) {
        if (_isDisposed) return;
        allStatuses = statuses;
        state = StatusState.data(allStatuses);
      },
      onError: (e) {
        if (_isDisposed) return;
        state = StatusState.error(e.toString());
      },
    );
  }

  List<StatusEntity> filterStatusesWithPrivacy({
    required String currentUserId,
    required StatusPrivacyState privacyState,
  }) {
    if (currentUserId.isEmpty) return [];

    return allStatuses.where((status) {
      switch (privacyState.selectedOption) {
        case StatusPrivacyOptionUI.allContacts:
          return true;
        case StatusPrivacyOptionUI.contactsExcept:
          return !privacyState.excludedContactsIds.contains(status.uid);
        case StatusPrivacyOptionUI.shareWithOnly:
          return privacyState.includedContactsIds.contains(status.uid);
      }
    }).toList();
  }
}

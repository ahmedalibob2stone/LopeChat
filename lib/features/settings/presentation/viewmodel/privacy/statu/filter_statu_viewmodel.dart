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
  List<StatusEntity> allStatuses = [];
        FilterStatuViewmodel(this.ref, this.privacyState,this.getStatusesUseCase) : super(StatusState.loading()) {
    _loadStatuses();
  }

  Future<void> _loadStatuses() async {
    try {
      state = StatusState.loading();
      allStatuses = await getStatusesUseCase();
      state = StatusState.data(allStatuses);
    } catch (e) {
      state = StatusState.error(e.toString());
    }
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

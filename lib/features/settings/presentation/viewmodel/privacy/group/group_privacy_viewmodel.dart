import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/widgets/check internat/check_internat.dart';
import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../domain/entities/privacy/group/group_privacy_entity.dart';
import '../../../../domain/usecases/privacy/group/get_group_privacy_usecase.dart';
import '../../../../domain/usecases/privacy/group/update_group_privacy_usecase.dart';
class GroupPrivacyOptions {
  static const everyone = 'everyone';
  static const myContacts = 'myContacts';
  static const myContactsExcept = 'myContactsExcept';

  static const labels = {
    everyone: 'Everyone',
    myContacts: 'My Contacts',
    myContactsExcept: 'My Contacts Except...',
  };
}

class GroupPrivacyState {
  final bool isLoading;
  final String selectedVisibility;
  final List<String> excludedUids;
  final List<UserEntity> filteredContacts;
  final bool hasChanges;
  final String? error;

  GroupPrivacyState({
    required this.isLoading,
    required this.selectedVisibility,
    required this.excludedUids,
    required this.filteredContacts,
    required this.hasChanges,
    this.error,
  });

  factory GroupPrivacyState.initial() {
    return GroupPrivacyState(
      isLoading: false,
      selectedVisibility: 'everyone',
      excludedUids: [],
      filteredContacts: [],
      hasChanges: false,
      error: null,
    );
  }

  GroupPrivacyState copyWith({
    bool? isLoading,
    String? selectedVisibility,
    List<String>? excludedUids,
    List<UserEntity>? filteredContacts,
    bool? hasChanges,
    String? error,
  }) {
    return GroupPrivacyState(
      isLoading: isLoading ?? this.isLoading,
      selectedVisibility: selectedVisibility ?? this.selectedVisibility,
      excludedUids: excludedUids ?? this.excludedUids,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      hasChanges: hasChanges ?? this.hasChanges,
      error: error,
    );
  }
}

class GroupPrivacyViewModel extends StateNotifier<GroupPrivacyState> {
  final GetGroupPrivacyUseCase getGroupPrivacyUseCase;
  final UpdateGroupPrivacyUseCase updateGroupPrivacyUseCase;
  final CheckInternet networkChecker;

  GroupPrivacyViewModel({
    required this.getGroupPrivacyUseCase,
    required this.updateGroupPrivacyUseCase,
    required this.networkChecker,
  }) : super(GroupPrivacyState.initial());

  Future<void> loadPrivacySettings(List<UserEntity> appUsers) async {
    if (!await networkChecker.IsConnected()) {
      state = state.copyWith(error: 'Network unavailable. Please try again later.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final entity = await getGroupPrivacyUseCase();
      state = state.copyWith(
        selectedVisibility: entity.visibility,
        excludedUids: entity.exceptUids,
        filteredContacts: appUsers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load settings.');
    }
  }

  Future<void> setVisibility(String visibility) async {
    if (!await networkChecker.IsConnected()) {
      state = state.copyWith(error: 'Network unavailable. Please try again later.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final entity = GroupPrivacyEntity(
        visibility: visibility,
        exceptUids: state.excludedUids,
      );

      await updateGroupPrivacyUseCase(entity);

      state = state.copyWith(
        selectedVisibility: visibility,
        isLoading: false,
        hasChanges: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong.');
    }
  }


  void toggleExcludedUid(String uid) {
    final currentList = List<String>.from(state.excludedUids);
    if (currentList.contains(uid)) {
      currentList.remove(uid);
    } else {
      currentList.add(uid);
    }
    state = state.copyWith(excludedUids: currentList, hasChanges: true);
  }

  void toggleSelectAll() {
    final allUids = state.filteredContacts.map((c) => c.uid).toList();
    final isAllSelected = allUids.every((uid) => state.excludedUids.contains(uid));

    state = state.copyWith(
      excludedUids: isAllSelected ? [] : allUids,
      hasChanges: true,
    );
  }

  Future<bool> saveExcludedContacts() async {
    if (!await networkChecker.IsConnected()) {
      state = state.copyWith(error: 'Network unavailable. Please try again later.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final entity = GroupPrivacyEntity(
        visibility: state.selectedVisibility,
        exceptUids: state.excludedUids,
      );

      await updateGroupPrivacyUseCase(entity);

      state = state.copyWith(isLoading: false, hasChanges: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to save exclusions.');
      return false;
    }
  }

  void loadContacts(List<UserEntity> contacts) {
    state = state.copyWith(filteredContacts: contacts);
  }

  bool isExcluded(String uid) {
    return state.excludedUids.contains(uid);
  }

  List<UserEntity> get sortedContacts {
    final excluded = state.filteredContacts
        .where((c) => state.excludedUids.contains(c.uid));
    final included = state.filteredContacts
        .where((c) => !state.excludedUids.contains(c.uid));
    return [...excluded, ...included];
  }
}

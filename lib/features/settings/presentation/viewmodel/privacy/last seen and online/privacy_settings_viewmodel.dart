import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../domain/entities/privacy/last seen and online/last_seen_and_online.dart';
import '../../../../domain/usecases/privacy/last seen and online/get_last_seen_and_online_usecase.dart';
import '../../../../domain/usecases/privacy/last seen and online/update_last_seen_and_online_usecase.dart';
class LastSeenAndOnlinePrivacyVisibility {
  static const everyone = 'everyone';
  static const myContacts = 'my contacts';
  static const myContactsExcept = 'my contacts except';
  static const nobody = 'nobody';
  static const sameAsLastSeen = 'same as last seen';
}
@immutable
class LastSeenAndOnlineState {
  final bool isLoading;
  final LastSeenAndOnlineEntity? privacySettings; // يحتوي على lastSeenVisibility, lastSeenExceptUids, onlineVisibility
  final List<UserEntity> filteredContacts;
  final String? error;
  final bool isSaving;
  final bool hasChanges;


  const LastSeenAndOnlineState({
    this.isLoading = false,
    this.privacySettings,
    this.filteredContacts = const [],
    this.error,
    this.isSaving = false,
    this.hasChanges =false
  });

  LastSeenAndOnlineState copyWith({
    bool? isLoading,
    LastSeenAndOnlineEntity? privacySettings,
    List<UserEntity>? filteredContacts,
    String? error,
    bool? isSaving,
    bool? hasChanges,
  }) {
    return LastSeenAndOnlineState(
      isLoading: isLoading ?? this.isLoading,
      privacySettings: privacySettings ?? this.privacySettings,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      error: error,
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
class LastSeenAndOnlineViewModel extends StateNotifier<LastSeenAndOnlineState> {
  final GetLastSeenAndOnlineUseCase getUseCase;
  final UpdateLastSeenAndOnlineUseCase updateUseCase;

  LastSeenAndOnlineViewModel({
    required this.getUseCase,
    required this.updateUseCase,
  }) : super(const LastSeenAndOnlineState());


  Future<void> setLastSeenVisibility(String newVisibility) async {
    if (state.privacySettings == null) return;

    state = state.copyWith(isSaving: true, error: null);

    final updatedPrivacy = LastSeenAndOnlineEntity(
      lastSeenVisibility: newVisibility,
      lastSeenExceptUids: state.privacySettings!.lastSeenExceptUids,
      onlineVisibility: state.privacySettings!.onlineVisibility,
    );

    try {
      await updateUseCase(updatedPrivacy);
      state = state.copyWith(
        privacySettings: updatedPrivacy,
        isSaving: false,
        error: null,
      );
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update privacy settings, please try again later',
      );
    }
  }

  Future<void> setOnlineVisibility(String newVisibility) async {
    if (state.privacySettings == null) return;

    state = state.copyWith(isSaving: true, error: null);

    final updatedPrivacy = LastSeenAndOnlineEntity(
      lastSeenVisibility: state.privacySettings!.lastSeenVisibility,
      lastSeenExceptUids: state.privacySettings!.lastSeenExceptUids,
      onlineVisibility: newVisibility,
    );

    try {
      await updateUseCase(updatedPrivacy);
      state = state.copyWith(
        privacySettings: updatedPrivacy,
        isSaving: false,
        error: null,
      );
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update privacy settings, please try again later',
      );
    }
  }

  void toggleExcludedUid(String uid) {
    if (state.privacySettings == null) return;

    final currentList = List<String>.from(state.privacySettings!.lastSeenExceptUids);
    if (currentList.contains(uid)) {
      currentList.remove(uid);
    } else {
      currentList.add(uid);
    }

    final updatedPrivacy = LastSeenAndOnlineEntity(
      lastSeenVisibility: state.privacySettings!.lastSeenVisibility,
      lastSeenExceptUids: currentList,
      onlineVisibility: state.privacySettings!.onlineVisibility,
    );

    state = state.copyWith(
      privacySettings: updatedPrivacy,
    );
  }

  Future<bool> saveExcludedUids() async {
    if (state.privacySettings == null) return false;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await updateUseCase(state.privacySettings!);
      state = state.copyWith(isSaving: false, error: null);
      return true;
    } catch (_) {
      state = state.copyWith(isSaving: false, error:
      'Failed to save changes, please try again later');
      return false;
    }
  }
  void toggleSelectAll() {
    if (state.privacySettings == null) return;

    final allUids = state.filteredContacts.map((e) => e.uid).toList();
    final isAllSelected = state.privacySettings!.lastSeenExceptUids.length == allUids.length;

    final updatedPrivacy = LastSeenAndOnlineEntity(
      lastSeenVisibility: state.privacySettings!.lastSeenVisibility,
      lastSeenExceptUids: isAllSelected ? [] : allUids,
      onlineVisibility: state.privacySettings!.onlineVisibility,
    );

    state = state.copyWith(
      privacySettings: updatedPrivacy,
      hasChanges: true,
    );
  }

  List<UserEntity> get sortedContacts {
    if (state.privacySettings == null) return state.filteredContacts;

    final excluded = state.filteredContacts.where((u) => state.privacySettings!.lastSeenExceptUids.contains(u.uid));
    final included = state.filteredContacts.where((u) => !state.privacySettings!.lastSeenExceptUids.contains(u.uid));

    return [...excluded, ...included];
  }
  bool canSeeLastSeen(String viewerUid) {
    final settings = state.privacySettings;
    if (settings == null) return false;

    if (settings.lastSeenVisibility == LastSeenAndOnlinePrivacyVisibility.nobody) return false;

    switch (settings.lastSeenVisibility) {
      case LastSeenAndOnlinePrivacyVisibility.everyone:
        return !settings.lastSeenExceptUids.contains(viewerUid);
      case LastSeenAndOnlinePrivacyVisibility.myContacts:
        return state.filteredContacts.any((u) => u.uid == viewerUid)
            && !settings.lastSeenExceptUids.contains(viewerUid);
      case LastSeenAndOnlinePrivacyVisibility.myContactsExcept:
        return !settings.lastSeenExceptUids.contains(viewerUid);
      default:
        return false;
    }
  }
  bool canSeeOnlineStatus(String viewerUid) {
    final settings = state.privacySettings;
    if (settings == null) return false;

    if (settings.onlineVisibility == LastSeenAndOnlinePrivacyVisibility.sameAsLastSeen) {
      return canSeeLastSeen(viewerUid);
    }

    if (settings.onlineVisibility == LastSeenAndOnlinePrivacyVisibility.nobody) return false;

    switch (settings.onlineVisibility) {
      case LastSeenAndOnlinePrivacyVisibility.everyone:
        return true;
      case LastSeenAndOnlinePrivacyVisibility.myContacts:
        return state.filteredContacts.any((u) => u.uid == viewerUid);
      case LastSeenAndOnlinePrivacyVisibility.myContactsExcept:
        return !settings.lastSeenExceptUids.contains(viewerUid); // (إن لم تنفذ onlineExceptUids بعد)
      default:
        return false;
    }
  }

  Future<void> loadDataForUser(String userId, List<UserEntity> contacts) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final privacy = await getUseCase(userId);
      state = state.copyWith(
        isLoading: false,
        privacySettings: privacy,
        filteredContacts: contacts,
        error: null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network unavailable, please try again later',
      );
    }
  }


}


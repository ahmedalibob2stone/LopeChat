import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/domain/usecases/get_current_user_id_usecase.dart';
import '../../../../domain/entities/privacy/privacy_profile/privacy_profile_entity.dart';
import '../../../../domain/usecases/privacy/profile/get_privacy_profile_settings_usecase.dart';
import '../../../../domain/usecases/privacy/profile/update_privacy_profile_settings_usecase.dart';
class ProfilePrivacyVisibility {
  static const everyone = 'everyone';
  static const myContacts = 'my contacts';
  static const myContactsExcept = 'my contacts except';
  static const nobody = 'nobody';
}
@immutable
class ProfilePhotoPrivacyState {
  final bool isLoading;
  final ProfileEntity? profilePrivacy;
  final List<UserEntity> filteredContacts;
  final String? error;
  final bool isSaving;
  final bool hasChanges;

  const ProfilePhotoPrivacyState({
    this.isLoading = false,
    this.profilePrivacy,
    this.filteredContacts = const [],
    this.error,
    this.isSaving = false,
    this.hasChanges = false,
  });

  ProfilePhotoPrivacyState copyWith({
    bool? isLoading,
    ProfileEntity? profilePrivacy,
    List<UserEntity>? filteredContacts,
    String? error,
    bool? isSaving,
    bool? hasChanges,
  }) {
    return ProfilePhotoPrivacyState(
      isLoading: isLoading ?? this.isLoading,
      profilePrivacy: profilePrivacy ?? this.profilePrivacy,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      error: error,
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

class ProfilePhotoPrivacyViewModel extends StateNotifier<ProfilePhotoPrivacyState> {
  final GetProfilePrivacyUseCase getUseCase;
  final UpdateProfilePrivacyUseCase updateUseCase;
  final GetCurrentUserIdUseCase getCurrentUserIdUseCase;

  ProfilePhotoPrivacyViewModel({
    required this.getUseCase,
    required this.updateUseCase,
    required this.getCurrentUserIdUseCase
  }) : super(const ProfilePhotoPrivacyState());

  Future<void> loadData(List<UserEntity> contacts) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await getUseCase();
      state = state.copyWith(
        isLoading: false,
        profilePrivacy: data,
        filteredContacts: contacts,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء تحميل إعدادات الخصوصية',
      );
    }
  }

  Future<void> setProfilePhotoVisibility(String visibility) async {
    if (state.profilePrivacy == null) return;

    state = state.copyWith(isSaving: true, error: null);

    final updated = ProfileEntity(
      visibility: visibility,
      exceptUids: state.profilePrivacy!.exceptUids,
    );

    try {
      await updateUseCase(updated);
      state = state.copyWith(
        profilePrivacy: updated,
        isSaving: false,
        hasChanges: false,
      );
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        error: 'فشل في تحديث إعدادات الخصوصية، حاول مرة أخرى',
      );
    }
  }

  void toggleExcludedUid(String uid) {
    if (state.profilePrivacy == null) return;

    final currentList = List<String>.from(state.profilePrivacy!.exceptUids);

    if (currentList.contains(uid)) {
      currentList.remove(uid);
    } else {
      currentList.add(uid);
    }

    final updated = ProfileEntity(
      visibility: state.profilePrivacy!.visibility,
      exceptUids: currentList,
    );

    state = state.copyWith(
      profilePrivacy: updated,
      hasChanges: true,
    );
  }

  void toggleSelectAll() {
    if (state.profilePrivacy == null) return;

    final allUids = state.filteredContacts.map((e) => e.uid).toList();
    final isAllSelected = allUids.every((uid) => state.profilePrivacy!.exceptUids.contains(uid));

    final updated = ProfileEntity(
      visibility: state.profilePrivacy!.visibility,
      exceptUids: isAllSelected ? [] : allUids,
    );

    state = state.copyWith(
      profilePrivacy: updated,
      hasChanges: true,
    );
  }

  Future<bool> saveChanges() async {
    if (state.profilePrivacy == null) return false;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await updateUseCase(state.profilePrivacy!);
      state = state.copyWith(isSaving: false, hasChanges: false);
      return true;
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        error: 'فشل في حفظ التغييرات',
      );
      return false;
    }
  }

  List<UserEntity> get sortedContacts {
    if (state.profilePrivacy == null) return state.filteredContacts;

    final excluded = state.filteredContacts.where(
          (u) => state.profilePrivacy!.exceptUids.contains(u.uid),
    );

    final included = state.filteredContacts.where(
          (u) => !state.profilePrivacy!.exceptUids.contains(u.uid),
    );

    return [...excluded, ...included];
  }
  ProfileEntity ? get currentUserProfilePrivacy => state.profilePrivacy;

  bool checkIfViewerInContacts(String profileOwnerUid, String viewerUid) {
    final contacts = state.filteredContacts; // يجب تحميل جهات اتصال المستخدم صاحب الملف
    return contacts.any((contact) => contact.uid == viewerUid);
  }
  bool canSeeProfilePhoto({required String profileOwnerUid, required String viewerUid,
    required List<String> ownerContactUids,}) {
    if (profileOwnerUid == viewerUid) return true;

    final settings = state.profilePrivacy;
    if (settings == null) return false;

    switch (settings.visibility) {
      case ProfilePrivacyVisibility.everyone:
        return !settings.exceptUids.contains(viewerUid);

      case ProfilePrivacyVisibility.myContacts:
        final isContact = ownerContactUids.contains(viewerUid);
        return isContact && !settings.exceptUids.contains(viewerUid);

      case ProfilePrivacyVisibility.myContactsExcept:
        final isContact = ownerContactUids.contains(viewerUid);
        return isContact && !settings.exceptUids.contains(viewerUid);

      case ProfilePrivacyVisibility.nobody:
        return false;

      default:
        return false;
    }
  }

}

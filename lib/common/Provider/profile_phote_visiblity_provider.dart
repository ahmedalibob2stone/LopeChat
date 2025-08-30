import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
import '../../features/profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../features/settings/presentation/provider/privacy/profile/vm/provider.dart';

final profilePhotoVisibilityProvider = FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final currentUserId = params['currentUserId'] ?? '';
  final otherUserId = params['otherUserId'] ?? '';

  if (currentUserId.isEmpty || otherUserId.isEmpty) return false;

  final blockVm = ref.read(blockUserViewModelProvider.notifier);
  final isBlocked = await blockVm.isblockUserUseCase.isBlocked(
    currentUserId: currentUserId,
    otherUserId: otherUserId,
  );

  if (isBlocked) {
    return false;
  }

  final contactsState = ref.read(getAppContactsViewModelProvider);
  final ownerContactUids = contactsState.contacts.map((e) => e.uid).toList();

  final privacyVm = ref.read(profilePrivacyForUserProvider(otherUserId).notifier);

  final isPrivacyAllowed = await privacyVm.canSeeProfilePhoto(
    profileOwnerUid: otherUserId,
    viewerUid: currentUserId,
    ownerContactUids: ownerContactUids,
  );

  return isPrivacyAllowed;
});

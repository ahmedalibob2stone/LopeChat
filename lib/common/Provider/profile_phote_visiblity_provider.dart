import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
import '../../features/contact/presentation/viewmodel/get_app_contacts_viewmodel.dart';
import '../../features/profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../features/settings/presentation/provider/privacy/profile/vm/provider.dart';
final profilePhotoVisibilityProvider =
FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final currentUserId = params['currentUserId'] ?? '';
  final otherUserId = params['otherUserId'] ?? '';

  // إذا أحدهما فارغ أو نفس المستخدم، لا حاجة للتحقق
  if (currentUserId.isEmpty || otherUserId.isEmpty || currentUserId == otherUserId) {
    return true; // يمكن عرض الصورة لنفسه
  }

  // تحقق من الحظر أولاً
  final blockVm = ref.read(blockUserViewModelProvider.notifier);
  final isBlocked = await blockVm.isblockUserUseCase.isBlocked(
    currentUserId: currentUserId,
    otherUserId: otherUserId,
  );

  if (isBlocked) return false;

  // جهات الاتصال
  final contactsState = ref.watch(getAppContactsViewModelProvider);
  final ownerContactUids = contactsState.contacts.map((e) => e.uid).toList();

  // إذا لم تُحمّل جهات الاتصال بعد، أرجع false مباشرة لتجنب الانتظار
  if (contactsState.status != ContactsStatus.loaded) {
    return false;
  }

  // إعدادات الخصوصية
  final privacyVm = ref.read(profilePrivacyForUserProvider(otherUserId).notifier);

  final settings = privacyVm.currentUserProfilePrivacy;
  if (settings == null) return false;

  final isPrivacyAllowed = privacyVm.canSeeProfilePhoto(
    profileOwnerUid: otherUserId,
    viewerUid: currentUserId,
    ownerContactUids: ownerContactUids,
  );

  return isPrivacyAllowed;
});

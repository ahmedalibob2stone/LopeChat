// lib/core/constants/app_strings.dart

enum AppLanguage { arabic, english }

class AppStrings {
  static AppLanguage currentLanguage = AppLanguage.arabic; // ← غيّر هنا لتبديل اللغة

  static String get blockedContactsTitle =>
      currentLanguage == AppLanguage.arabic ? 'جهات الاتصال المحظورة' : 'Blocked Contacts';

  static String get noBlockedContacts =>
      currentLanguage == AppLanguage.arabic ? 'لا توجد جهات اتصال محظورة' : 'No blocked contacts';

  static String get addContactHint =>
      currentLanguage == AppLanguage.arabic
          ? 'اضغط على أيقونة + لتحديد جهات اتصال وحظرها'
          : 'Tap the + icon to block contacts';

  static String get contactListTitle =>
      currentLanguage == AppLanguage.arabic ? 'جهات الاتصال' : 'Contacts';

  static String get pleaseWait =>
      currentLanguage == AppLanguage.arabic ? 'الرجاء الانتظار لحظة...' : 'Please wait...';

  static String get errorUpdatingPrivacy =>
      currentLanguage == AppLanguage.arabic
          ? 'فشل تحديث الخصوصية. الرجاء المحاولة لاحقًا.'
          : 'Privacy update failed. Please try again.';

  static String get unblockConfirmation =>
      currentLanguage == AppLanguage.arabic ? 'رفع الحظر عن هذا المستخدم؟' : 'Unblock this user?';

  static String get userUnblocked =>
      currentLanguage == AppLanguage.arabic ? 'تم رفع الحظر' : 'User unblocked';

  static String get noContacts =>
      currentLanguage == AppLanguage.arabic ? 'لا توجد جهات اتصال' : 'No contacts found';

  static String get selectContact =>
      currentLanguage == AppLanguage.arabic ? 'تحديد جهة اتصال' : 'Select contact';

  static String get blockedCannotCall =>
      currentLanguage == AppLanguage.arabic
          ? 'لن تتمكن جهات الاتصال المحظورة من الاتصال بك'
          : 'Blocked contacts can’t call you.';

  static String get cancel =>
      currentLanguage == AppLanguage.arabic ? 'إلغاء' : 'Cancel';

  static String get unblock =>
      currentLanguage == AppLanguage.arabic ? 'رفع الحظر' : 'Unblock';
}

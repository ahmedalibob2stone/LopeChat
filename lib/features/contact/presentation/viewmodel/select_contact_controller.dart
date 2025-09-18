import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/check internat/check_internat.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/usecase/get_all_contacts.dart';

enum ContactsLoadStatus { initial, loading, loaded, error }

class ContactsStateManager {
  final ContactsLoadStatus status;
  final List<UserEntity> appContacts;
  final List<UserEntity> nonAppContacts;
  final String? errorMessage;

  ContactsStateManager({
    required this.status,
    this.appContacts = const [],
    this.nonAppContacts = const [],
    this.errorMessage,
  });

  factory ContactsStateManager.initial() =>
      ContactsStateManager(status: ContactsLoadStatus.initial);

  ContactsStateManager copyWith({
    ContactsLoadStatus? status,
    List<UserEntity>? appContacts,
    List<UserEntity>? nonAppContacts,
    String? errorMessage,
  }) {
    return ContactsStateManager(
      status: status ?? this.status,
      appContacts: appContacts ?? this.appContacts,
      nonAppContacts: nonAppContacts ?? this.nonAppContacts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class GetAllContactsViewModel extends StateNotifier<ContactsStateManager> {
  final GetAllContactsUseCase getAllContactsUseCase;
  final String currentUserPhone;
  final String currentUserCountry;

  GetAllContactsViewModel({
    required this.getAllContactsUseCase,
    required this.currentUserPhone,
    required this.currentUserCountry,
  }) : super(ContactsStateManager.initial()) {
    loadAppContacts();
  }

  Future<void> loadAppContacts() async {
    state = state.copyWith(status: ContactsLoadStatus.loading, errorMessage: null);

    try {
      final localData = await getAllContactsUseCase.call(
        currentUserPhone: currentUserPhone,
        currentUserCountry: currentUserCountry,
      );

      final appContacts = localData['appContacts'] ?? [];
      final nonAppContacts = localData['nonAppContacts'] ?? [];

      state = state.copyWith(
        status: ContactsLoadStatus.loaded,
        appContacts: appContacts,
        nonAppContacts: nonAppContacts,
      );
    } catch (e) {
      state = state.copyWith(
        status: ContactsLoadStatus.error,
        errorMessage: "Error occurred: $e",
      );
    }
  }

  Future<void> refreshContacts({required void Function(String) showMessage}) async {
    // حالة التحميل
    state = state.copyWith(status: ContactsLoadStatus.loading, errorMessage: null);

    try {
      final localData = await getAllContactsUseCase.call(
        currentUserPhone: currentUserPhone,
        currentUserCountry: currentUserCountry,
      );

      final nonAppContacts = localData['nonAppContacts'] ?? [];

      final connected = await CheckInternet.isConnected();

      // جهات الاتصال مستخدمي التطبيق
      final appContacts = connected
          ? (localData['appContacts'] ?? [])
          : state.appContacts;

      if (!connected) {
        showMessage("No internet connection.");
      }

      state = state.copyWith(
        status: ContactsLoadStatus.loaded,
        appContacts: appContacts,
        nonAppContacts: nonAppContacts,
      );
    } catch (e) {
      state = state.copyWith(
        status: ContactsLoadStatus.error,
        errorMessage: " error occurred: $e",
      );
    }
  }

}

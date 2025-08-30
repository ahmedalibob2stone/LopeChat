import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../domain/entities/privacy/statu/statu_privacy_entity.dart';
import '../../../../domain/usecases/privacy/statu/get_status_privacy_usecase.dart';
import '../../../../domain/usecases/privacy/statu/set_status_privacy_usecase.dart';

enum StatusPrivacyOptionUI {
  allContacts,
  contactsExcept,
  shareWithOnly,
}

class StatusPrivacyState {
  final StatusPrivacyOptionUI selectedOption;
  final List<String> excludedContactsIds;
  final List<String> includedContactsIds;
  final List<UserEntity> filteredContacts;
  final String message;
  final String searchQuery;

  StatusPrivacyState({
    required this.selectedOption,
    required this.excludedContactsIds,
    required this.includedContactsIds,
    required this.filteredContacts,
    this.message = '',
    this.searchQuery = '',
  });

  StatusPrivacyState copyWith({
    StatusPrivacyOptionUI? selectedOption,
    List<String>? excludedContactsIds,
    List<String>? includedContactsIds,
    List<UserEntity>? filteredContacts,
    String? message,
    String? searchQuery,  // <-- أضفنا هنا
  }) {
    return StatusPrivacyState(
      selectedOption: selectedOption ?? this.selectedOption,
      excludedContactsIds: excludedContactsIds ?? this.excludedContactsIds,
      includedContactsIds: includedContactsIds ?? this.includedContactsIds,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  int get excludedCount => excludedContactsIds.length;
  int get includedCount => includedContactsIds.length;
}

class StatusPrivacyViewModel extends StateNotifier<StatusPrivacyState> {
  final GetStatusPrivacyUseCase getUseCase;
  final SetStatusPrivacyUseCase setUseCase;
  final List<UserEntity> localContacts;

  StatusPrivacyViewModel({
    required this.getUseCase,
    required this.setUseCase,
    required this.localContacts,
  }) : super(StatusPrivacyState(
    selectedOption: StatusPrivacyOptionUI.allContacts,
    excludedContactsIds: [],
    includedContactsIds: [],
    filteredContacts: [],
  )) {
    loadPrivacy();
  }

  Future<void> loadPrivacy() async {
    // تحميل الإعدادات المخزنة
    final entity = await getUseCase();
    if (entity != null) {
      state = state.copyWith(
        selectedOption: _convertOption(entity.option),
        excludedContactsIds: List.from(entity.excludedContactsIds),
        includedContactsIds: List.from(entity.includedContactsIds),
      );
    }
    _refreshFilteredContacts();
  }

  StatusPrivacyOptionUI _convertOption(StatusPrivacyOption option) {
    switch (option) {
      case StatusPrivacyOption.allContacts:
        return StatusPrivacyOptionUI.allContacts;
      case StatusPrivacyOption.contactsExcept:
        return StatusPrivacyOptionUI.contactsExcept;
      case StatusPrivacyOption.shareWithOnly:
        return StatusPrivacyOptionUI.shareWithOnly;
    }
  }

  StatusPrivacyOption _toEntityOption(StatusPrivacyOptionUI option) {
    switch (option) {
      case StatusPrivacyOptionUI.allContacts:
        return StatusPrivacyOption.allContacts;
      case StatusPrivacyOptionUI.contactsExcept:
        return StatusPrivacyOption.contactsExcept;
      case StatusPrivacyOptionUI.shareWithOnly:
        return StatusPrivacyOption.shareWithOnly;
    }
  }


  void selectOption(StatusPrivacyOptionUI option) {
    List<String> excluded = state.excludedContactsIds;
    List<String> included = state.includedContactsIds;

    if (option == StatusPrivacyOptionUI.allContacts) {
      excluded = [];
      included = [];
    }
    state = state.copyWith(
      selectedOption: option,
      excludedContactsIds: excluded,
      includedContactsIds: included,
      message: '',
    );
    _refreshFilteredContacts();
  }

  void toggleExcludedContact(String contactId) {
    final excluded = List<String>.from(state.excludedContactsIds);
    if (excluded.contains(contactId)) {
      excluded.remove(contactId);
    } else {
      excluded.add(contactId);
    }
    state = state.copyWith(excludedContactsIds: excluded, message: 'update Settings');
    _refreshFilteredContacts();
  }

  /// تبديل حالة شخص في قائمة المضمنين
  void toggleIncludedContact(String contactId) {
    final included = List<String>.from(state.includedContactsIds);
    if (included.contains(contactId)) {
      included.remove(contactId);
    } else {
      included.add(contactId);
    }
    state = state.copyWith(includedContactsIds: included, message: 'update Settings');
    _refreshFilteredContacts();
  }
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _refreshFilteredContacts();
  }
  void _refreshFilteredContacts() {
    List<UserEntity> contacts = List.from(localContacts);
    if (state.searchQuery.isNotEmpty) {
      contacts = contacts.where((c) {
        return c.name.toLowerCase().contains(state.searchQuery.toLowerCase());
      }).toList();
    }
    if (state.selectedOption == StatusPrivacyOptionUI.contactsExcept) {
      contacts.sort((a, b) {
        final aSelected = state.excludedContactsIds.contains(a.uid);
        final bSelected = state.excludedContactsIds.contains(b.uid);

        if (aSelected && !bSelected) return -1;
        if (!aSelected && bSelected) return 1;
        return 0;
      });
    } else if (state.selectedOption == StatusPrivacyOptionUI.shareWithOnly) {
      contacts.sort((a, b) {
        final aSelected = state.includedContactsIds.contains(a.uid);
        final bSelected = state.includedContactsIds.contains(b.uid);

        if (aSelected && !bSelected) return -1;
        if (!aSelected && bSelected) return 1;
        return 0;
      });
    }

    state = state.copyWith(filteredContacts: contacts);
  }


  Future<void> applyChanges() async {
    final entity = StatusPrivacyEntity(
      option: _toEntityOption(state.selectedOption),
      excludedContactsIds: state.excludedContactsIds,
      includedContactsIds: state.includedContactsIds,
    );
    await setUseCase.call(entity);

    state = state.copyWith(message: 'update Settings');
  }

  void selectAll() {
    final ids = state.filteredContacts.map((u) => u.uid).toList();
    if (state.selectedOption == StatusPrivacyOptionUI.contactsExcept) {
      state = state.copyWith(excludedContactsIds: ids, message: 'update Settings');
    } else if (state.selectedOption == StatusPrivacyOptionUI.shareWithOnly) {
      state = state.copyWith(includedContactsIds: ids, message: 'update Settings');
    }
    _refreshFilteredContacts();
  }

  void unselectAll() {

    if (state.selectedOption == StatusPrivacyOptionUI.contactsExcept) {
      state = state.copyWith(excludedContactsIds: [], message: 'update Settings');
    } else if (state.selectedOption == StatusPrivacyOptionUI.shareWithOnly) {
      state = state.copyWith(includedContactsIds: [], message: 'update Settings');
    }
    _refreshFilteredContacts();
  }
  void clearMessage() {
    state = state.copyWith(message: 'update Settings');
  }

}

    import '../../../user/domain/entities/user_entity.dart';
    import '../repositories/contact_repository.dart';

    class GetAppContactsUseCase {
      final IContactRepository repository;
      final String uid; // إذا كان ضروري حسب منطقك
      final String currentUserCountry; // إضافة الدولة الحالية

      GetAppContactsUseCase({
        required this.repository,
        required this.uid,
        required this.currentUserCountry,
      });

      Future<List<UserEntity>> call() async {
        return await repository.getAppContacts(
          currentUserCountry: currentUserCountry,
        );
      }
    }

abstract class EmailRepository {
  Future<String?> getEmail();
  Future<void> setEmail(String email);
  Future<void> clearEmail();
}

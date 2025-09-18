  import 'package:phone_numbers_parser/phone_numbers_parser.dart';

  String normalizePhone(String phone, {required IsoCode defaultCountry}) {
    try {
      final parsed = PhoneNumber.parse(phone, callerCountry: defaultCountry);
      return parsed.international; // يرجع الرقم بصيغة +967... أو +20...
    } catch (e) {
      return phone.replaceAll(RegExp(r'[^\d+]'), '');
    }
  }

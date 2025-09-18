import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../common/normalizephone/normalize_phone.dart';
import '../../../user/data/user_model/user_model.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

// خريطة تحويل رمز الدولة من String إلى IsoCode
final Map<String, IsoCode> countryIsoMap = {
  'YE': IsoCode.YE,
  'EG': IsoCode.EG,
  'US': IsoCode.US,
  'SA': IsoCode.SA,
  "AC": IsoCode.AC,
  "AD": IsoCode.AD,
  "AE": IsoCode.AE,
  "AF": IsoCode.AF,
  "AG": IsoCode.AG,
  "AI": IsoCode.AI,
  "AL": IsoCode.AL,
  "AM": IsoCode.AM,
  "AO": IsoCode.AO,
  "AR": IsoCode.AR,
  "AS": IsoCode.AS,
  "AT": IsoCode.AT,
  "AU": IsoCode.AU,
  "AW": IsoCode.AW,
  "AX": IsoCode.AX,
  "AZ": IsoCode.AZ,
  "BA": IsoCode.BA,
  "BB": IsoCode.BB,
  "BD": IsoCode.BD,
  "BE": IsoCode.BE,
  "BF": IsoCode.BF,
  "BG": IsoCode.BG,
  "BH": IsoCode.BH,
  "BI": IsoCode.BI,
  "BJ": IsoCode.BJ,
  "BL": IsoCode.BL,
  "BM": IsoCode.BM,
  "BN": IsoCode.BN,
  "BO": IsoCode.BO,
  "BQ": IsoCode.BQ,
  "BR": IsoCode.BR,
  "BS": IsoCode.BS,
  "BT": IsoCode.BT,
  "BW": IsoCode.BW,
  "BY": IsoCode.BY,
  "BZ": IsoCode.BZ,
  "CA": IsoCode.CA,
  "CC": IsoCode.CC,
  "CD": IsoCode.CD,
  "CF": IsoCode.CF,
  "CG": IsoCode.CG,
  "CH": IsoCode.CH,
  "CI": IsoCode.CI,
  "CK": IsoCode.CK,
  "CL": IsoCode.CL,
  "CM": IsoCode.CM,
  "CN": IsoCode.CN,
  "CO": IsoCode.CO,
  "CR": IsoCode.CR,
  "CU": IsoCode.CU,
  "CV": IsoCode.CV,
  "CW": IsoCode.CW,
  "CX": IsoCode.CX,
  "CY": IsoCode.CY,
  "CZ": IsoCode.CZ,
  "DE": IsoCode.DE,
  "DJ": IsoCode.DJ,
  "DK": IsoCode.DK,
  "DM": IsoCode.DM,
  "DO": IsoCode.DO,
  "DZ": IsoCode.DZ,
  "EC": IsoCode.EC,
  "EE": IsoCode.EE,
  "EH": IsoCode.EH,
  "ER": IsoCode.ER,
  "ES": IsoCode.ES,
  "ET": IsoCode.ET,
  "FI": IsoCode.FI,
  "FJ": IsoCode.FJ,
  "FK": IsoCode.FK,
  "FM": IsoCode.FM,
  "FO": IsoCode.FO,
  "FR": IsoCode.FR,
  "GA": IsoCode.GA,
  "GB": IsoCode.GB,
  "GD": IsoCode.GD,
  "GE": IsoCode.GE,
  "GF": IsoCode.GF,
  "GG": IsoCode.GG,
  "GH": IsoCode.GH,
  "GI": IsoCode.GI,
  "GL": IsoCode.GL,
  "GM": IsoCode.GM,
  "GN": IsoCode.GN,
  "GP": IsoCode.GP,
  "GQ": IsoCode.GQ,
  "GR": IsoCode.GR,
  "GT": IsoCode.GT,
  "GU": IsoCode.GU,
  "GW": IsoCode.GW,
  "GY": IsoCode.GY,
  "HK": IsoCode.HK,
  "HN": IsoCode.HN,
  "HR": IsoCode.HR,
  "HT": IsoCode.HT,
  "HU": IsoCode.HU,
  "ID": IsoCode.ID,
  "IE": IsoCode.IE,
  "IL": IsoCode.IL,
  "IM": IsoCode.IM,
  "IN": IsoCode.IN,
  "IO": IsoCode.IO,
  "IQ": IsoCode.IQ,
  "IR": IsoCode.IR,
  "IS": IsoCode.IS,
  "IT": IsoCode.IT,
  "JE": IsoCode.JE,
  "JM": IsoCode.JM,
  "JO": IsoCode.JO,
  "JP": IsoCode.JP,
  "KE": IsoCode.KE,
  "KG": IsoCode.KG,
  "KH": IsoCode.KH,
  "KI": IsoCode.KI,
  "KM": IsoCode.KM,
  "KN": IsoCode.KN,
  "KP": IsoCode.KP,
  "KR": IsoCode.KR,
  "KW": IsoCode.KW,
  "KY": IsoCode.KY,
  "KZ": IsoCode.KZ,
  "LA": IsoCode.LA,
  "LB": IsoCode.LB,
  "LC": IsoCode.LC,
  "LI": IsoCode.LI,
  "LK": IsoCode.LK,
  "LR": IsoCode.LR,
  "LS": IsoCode.LS,
  "LT": IsoCode.LT,
  "LU": IsoCode.LU,
  "LV": IsoCode.LV,
  "LY": IsoCode.LY,
  "MA": IsoCode.MA,
  "MC": IsoCode.MC,
  "MD": IsoCode.MD,
  "ME": IsoCode.ME,
  "MF": IsoCode.MF,
  "MG": IsoCode.MG,
  "MH": IsoCode.MH,
  "MK": IsoCode.MK,
  "ML": IsoCode.ML,
  "MM": IsoCode.MM,
  "MN": IsoCode.MN,
  "MO": IsoCode.MO,
  "MP": IsoCode.MP,
  "MQ": IsoCode.MQ,
  "MR": IsoCode.MR,
  "MS": IsoCode.MS,
  "MT": IsoCode.MT,
  "MU": IsoCode.MU,
  "MV": IsoCode.MV,
  "MW": IsoCode.MW,
  "MX": IsoCode.MX,
  "MY": IsoCode.MY,
  "MZ": IsoCode.MZ,
  "NA": IsoCode.NA,
  "NC": IsoCode.NC,
  "NE": IsoCode.NE,
  "NF": IsoCode.NF,
  "NG": IsoCode.NG,
  "NI": IsoCode.NI,
  "NL": IsoCode.NL,
  "NO": IsoCode.NO,
  "NP": IsoCode.NP,
  "NR": IsoCode.NR,
  "NU": IsoCode.NU,
  "NZ": IsoCode.NZ,
  "OM": IsoCode.OM,
  "PA": IsoCode.PA,
  "PE": IsoCode.PE,
  "PF": IsoCode.PF,
  "PG": IsoCode.PG,
  "PH": IsoCode.PH,
  "PK": IsoCode.PK,
  "PL": IsoCode.PL,
  "PM": IsoCode.PM,
  "PR": IsoCode.PR,
  "PS": IsoCode.PS,
  "PT": IsoCode.PT,
  "PW": IsoCode.PW,
  "PY": IsoCode.PY,
  "QA": IsoCode.QA,
  "RE": IsoCode.RE,
  "RO": IsoCode.RO,
  "RS": IsoCode.RS,
  "RU": IsoCode.RU,
  "RW": IsoCode.RW,
  "SB": IsoCode.SB,
  "SC": IsoCode.SC,
  "SD": IsoCode.SD,
  "SE": IsoCode.SE,
  "SG": IsoCode.SG,
  "SH": IsoCode.SH,
  "SI": IsoCode.SI,
  "SJ": IsoCode.SJ,
  "SK": IsoCode.SK,
  "SL": IsoCode.SL,
  "SM": IsoCode.SM,
  "SN": IsoCode.SN,
  "SO": IsoCode.SO,
  "SR": IsoCode.SR,
  "SS": IsoCode.SS,
  "ST": IsoCode.ST,
  "SV": IsoCode.SV,
  "SX": IsoCode.SX,
  "SY": IsoCode.SY,
  "SZ": IsoCode.SZ,
  "TA": IsoCode.TA,
  "TC": IsoCode.TC,
  "TD": IsoCode.TD,
  "TG": IsoCode.TG,
  "TH": IsoCode.TH,
  "TJ": IsoCode.TJ,
  "TK": IsoCode.TK,
  "TL": IsoCode.TL,
  "TM": IsoCode.TM,
  "TN": IsoCode.TN,
  "TO": IsoCode.TO,
  "TR": IsoCode.TR,
  "TT": IsoCode.TT,
  "TV": IsoCode.TV,
  "TW": IsoCode.TW,
  "TZ": IsoCode.TZ,
  "UA": IsoCode.UA,
  "UG": IsoCode.UG,
  "UY": IsoCode.UY,
  "UZ": IsoCode.UZ,
  "VA": IsoCode.VA,
  "VC": IsoCode.VC,
  "VE": IsoCode.VE,
  "VG": IsoCode.VG,
  "VI": IsoCode.VI,
  "VN": IsoCode.VN,
  "VU": IsoCode.VU,
  "WF": IsoCode.WF,
  "WS": IsoCode.WS,
  "XK": IsoCode.XK,
  "YT": IsoCode.YT,
  "ZA": IsoCode.ZA,
  "ZM": IsoCode.ZM,
  "ZW": IsoCode.ZW,
};

class FirebaseContactDataSource {
  final FirebaseFirestore firestore;

  FirebaseContactDataSource({required this.firestore});

  Future<Map<String, List<UserModel>>> getAllContacts({
    required String currentUserPhone,
    required String currentUserCountry,
  }) async {
    final isoCode = countryIsoMap[currentUserCountry] ?? IsoCode.YE;

    final normalizedCurrentUserPhone = normalizePhone(
      currentUserPhone,
      defaultCountry: isoCode,
    );

    List<UserModel> firebaseContacts = [];
    List<Contact> phoneContacts = [];

    // طلب صلاحية الوصول لجهات الاتصال
    final permissionGranted = await FlutterContacts.requestPermission();
    if (permissionGranted) {
      phoneContacts = await FlutterContacts.getContacts(withProperties: true);
    } else {
      // إذا لم تُمنح الصلاحية، أظهر قائمة فارغة
      phoneContacts = [];
    }

    // جلب كل المستخدمين من Firestore
    try {
      var userCollection = await firestore.collection('users').get();
      for (var doc in userCollection.docs) {
        firebaseContacts.add(UserModel.fromMap(doc.data()));
      }
    } catch (e) {
      // إذا فشل الاتصال، نترك firebaseContacts فارغة
      firebaseContacts = [];
    }

    List<UserModel> appContacts = [];
    List<UserModel> nonAppContacts = [];

    for (var contact in phoneContacts) {
      if (contact.phones.isEmpty) continue;

      String phoneNumber = normalizePhone(
        contact.phones.first.number,
        defaultCountry: isoCode,
      );

      if (phoneNumber == normalizedCurrentUserPhone) continue;

      bool isAppUser = false;

      for (var firebaseContact in firebaseContacts) {
        final firebasePhone = normalizePhone(
          firebaseContact.phoneNumber,
          defaultCountry: isoCode,
        );

        if (firebasePhone == phoneNumber) {
          appContacts.add(firebaseContact);
          isAppUser = true;
          break;
        }
      }

      if (!isAppUser && phoneNumber.isNotEmpty) {
        nonAppContacts.add(UserModel(
          name: contact.displayName.isNotEmpty
              ? contact.displayName
              : phoneNumber,
          phoneNumber: phoneNumber,
          uid: '',
          profile: '',
          isOnline: 'false',
          groupId: [],
          statu: '',
          lastSeen: '',
          blockedUsers: [],
        ));
      }
    }

    // إزالة التكرار
    final uniqueAppContacts = {for (var c in appContacts) c.uid: c};
    final uniqueNonAppContacts = {for (var c in nonAppContacts) c.phoneNumber: c};

    return {
      'appContacts': uniqueAppContacts.values.toList(),
      'nonAppContacts': uniqueNonAppContacts.values.toList(),
    };
  }



  Future<List<UserModel>> getAppContacts({required String currentUserCountry}) async {
    try {
      // جلب جهات الاتصال من الهاتف
      List<Contact> phoneContacts = [];
      bool permissionGranted = await FlutterContacts.requestPermission();
      if (!permissionGranted) {
        log('Permission to access contacts denied');
        return [];
      }
      phoneContacts = await FlutterContacts.getContacts(withProperties: true);

      // جلب مستخدمي Firebase
      List<UserModel> firebaseContacts = [];
      var userCollection = await firestore.collection('users').get();
      for (var document in userCollection.docs) {
        firebaseContacts.add(UserModel.fromMap(document.data()));
      }

      // مقارنة جهات الاتصال المحلية بمستخدمي التطبيق
      List<UserModel> appContacts = [];
      for (var contact in phoneContacts) {
        if (contact.phones.isEmpty) continue;

        String phoneNumber = normalizePhone(
          contact.phones.first.number,
          defaultCountry: countryIsoMap[currentUserCountry] ?? IsoCode.YE,
        );

        for (var firebaseContact in firebaseContacts) {
          String firebasePhone = normalizePhone(
            firebaseContact.phoneNumber,
            defaultCountry: countryIsoMap[currentUserCountry]?? IsoCode.YE,
          );
          if (firebasePhone == phoneNumber) {
            appContacts.add(firebaseContact);
            break;
          }
        }
      }

      log("App contacts: ${appContacts.map((c) => c.name).toList()}");
      return appContacts;
    } catch (e, stack) {
      log('Error in getAppContacts: $e', stackTrace: stack);
      return [];
    }
  }
}

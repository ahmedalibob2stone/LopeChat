import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lopechat/responsive/mobile_screen_Layout.dart';
import 'constant.dart';
import 'features/auth/presentation/screan/OTP_screan.dart';
import 'features/auth/presentation/screan/login_screan.dart';
import 'features/chat/presentaion/screan/archived_chats_screen.dart';
import 'features/chat/presentaion/screan/mobile_chat_screan.dart';
import 'features/contact/presentation/view/newpage.dart';
import 'features/contact/presentation/view/select_contact_screan.dart';
import 'features/contact/presentation/view/widget/contacts_screan.dart';
import 'features/group/presentation/view/create_group_screan.dart';
import 'features/group/presentation/view/group_member.dart';


import 'features/profile/presentation/screan/profile_screan.dart';
import 'features/profile/presentation/screan/widgets/encryption_info_screen.dart';
import 'features/settings/presentation/screan/settings/acount/account manage/add_account_screen.dart';
import 'features/settings/presentation/screan/settings/acount/account_details_screan.dart';
import 'features/settings/presentation/screan/settings/acount/change number/change_number_info_screan.dart';
import 'features/settings/presentation/screan/settings/acount/change number/enter_phone_number.dart';
import 'features/settings/presentation/screan/settings/acount/change number/success_screan.dart';
import 'features/settings/presentation/screan/settings/acount/delete account/delete_account_screen.dart';
import 'features/settings/presentation/screan/settings/acount/email/email_screen.dart';
import 'features/settings/presentation/screan/settings/acount/report/report_screan.dart';
import 'features/settings/presentation/screan/settings/acount/security/security_notification_screan.dart';
import 'features/settings/presentation/screan/settings/acount/twostep/set_pin_screan.dart';
import 'features/settings/presentation/screan/settings/acount/twostep/two_step_verification_screen.dart';
import 'features/settings/presentation/screan/settings/privacy/about/privacy_about_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/advanced/advanced_privacy_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/app lock/app_lock_gate.dart';
import 'features/settings/presentation/screan/settings/privacy/app lock/app_lock_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/auto disappear screan/auth_disappear_massage_titel.dart';
import 'features/settings/presentation/screan/settings/privacy/block/blocked_users_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/block/select_contact_to_block_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/call/privacy_calls_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/camera effect/camera_effects_listtile.dart';
import 'features/settings/presentation/screan/settings/privacy/group/excluded_contact_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/group/group_privacy_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/last seen and online/excluded_contact_last_seen_and_online_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/last seen and online/last_seen_and_online_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/links/links_privacy_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/privacy_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/profile/excluded_contacts_profile_privacy_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/profile/profile_privacy_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/review/account_protection_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/review/add_big_privacy_to _your _chats.dart';
import 'features/settings/presentation/screan/settings/privacy/review/control_in_my_private_information.dart';
import 'features/settings/presentation/screan/settings/privacy/review/privacy_settings_review_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/review/select_who_can_connect_with_you.dart';
import 'features/settings/presentation/screan/settings/privacy/status/my_contact_exception_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/status/onlyshare_with_screan.dart';
import 'features/settings/presentation/screan/settings/privacy/status/status_privacy_scraen.dart';
import 'features/settings/presentation/screan/settings/profile_screan/update_profile_screan.dart';
import 'features/status/presentation/screan/status_screan.dart';
import 'features/status/presentation/screan/widget/select_status_screan.dart';
import 'features/user/data/user_model/user_model.dart';
import 'features/user/presentation/ui/ckeck_user.dart';
import 'features/user/presentation/ui/user_info_screan.dart';
import 'features/welcome/screans/landing_screan.dart';


class OnGenerateRoutes{
    static Route<dynamic>? route(RouteSettings settings) {
      switch (settings.name) {
        case PageConst.checkUser:
          {
            return MaterialPageRoute(builder: (_) => CheckUserScreen());
          }
        case PageConst.Welcome_Screan:
          {
            return MaterialPageRoute(builder: (_) => Welcome_Screan());
          }

        case PageConst.LoginScrean:
          {
            return MaterialPageRoute(builder: (_) => LoginScreen());
          }



        case PageConst.otp_screan:
          final args = settings.arguments as Map<String, dynamic>;
          final isFromAddAccount = args['isFromAddAccount'] as bool;
          final phoneNumber = args['phoneNumber'] ;

          return routeBuilder(VerifyScreen(
            isFromAddAccount: isFromAddAccount, phoneNumber: phoneNumber,
          ));

      case PageConst.ProfileScreen:
        {
          return routeBuilder(
              ProfileScreen());
        }
      case PageConst.ContactsScrean:


        {
          return MaterialPageRoute(
              builder: (context) =>

            ContactPage()

          );
        }

      case PageConst.AddAccountScreen:
        {
          return routeBuilder(
              AddAccountScreen());
        }

      case PageConst.MobileScreenLayout:
        {
          return routeBuilder(
              MobileScreenLayout());
        }

      case PageConst.ContactsScrean:
        {
          return MaterialPageRoute(
              builder: (context) =>
              ContactPage()

          );
        }
      case PageConst.mobileChatScrean:
        final arguments = settings.arguments as Map<String, dynamic>;
        final name = arguments['name'] ?? '';
        final uid = arguments['uid']?? '';
        final isGroupChat = arguments['isGroupChat']?? '';
        final profilePic = arguments['profilePic']?? '';


            {
          return routeBuilder(
              MobileChatScrean(isGroupChat: isGroupChat,
                name: name,
                uid: uid,
                profilePic: profilePic,
              ));
        }
      case PageConst.status:
        final photofromgallery = settings.arguments as File;
            {
          return routeBuilder(
              SelectStatusScreen(file: photofromgallery,));
        }
      case PageConst.StatusScrean:
        final arguments = settings.arguments as Map<String, dynamic>;
        final username = arguments['username'] ?? 'Unknown';
        final profilePic = arguments['profilePic'] ?? 'default_profile_pic_url';
        final phoneNumber = arguments['phoneNumber'] ?? 'Unknown';
        final PhotoUrl = arguments['PhotoUrl'] ?? 'default_photo_url';
        final massage = arguments['PhotoUrl'] ?? 'default_photo_url';
        final uid = arguments['uid'] ?? 'Unknown';


         {
          return routeBuilder(
              StatusScreen(username: username,
                profilePic: profilePic,
                phoneNumber: phoneNumber,
                photoUrls: PhotoUrl,
                massage: massage,
                uid: uid,

              ));
        }
      case PageConst.GroupScrean:
        {
          return routeBuilder(
              CreateGroupScreen());
        }
      case PageConst.Profile_Chat:
        final arguments = settings.arguments as Map<String, dynamic>;
        final name = arguments['name'];
        final uid = arguments['uid'];
        final profilePic = arguments['profile'];
        {
          return routeBuilder(
              ProfileChat(uid: uid, profilePic: profilePic, name: name));
        }
      case PageConst.Profile_group:
        final arguments = settings.arguments as Map<String, dynamic>;
        final groupId = arguments['groupId'];
        return routeBuilder(
            GroupMember(groupId: groupId,));



      case PageConst.Edit_Profile:{return routeBuilder(EditProfileScreen());}

      case PageConst.Add_Usr_To_Group:
        final arguments=settings.arguments as Map<String ,dynamic>;
        final GroupId=arguments['GroupId'];


      case PageConst.Encryption_Info_Screen:
        final arguments=settings.arguments as Map<String ,dynamic>;
        return routeBuilder(EncryptionInfoScreen());

           //archiveScreen

      case PageConst.archiveScreen:
        return routeBuilder(ArchivedChatsScreen());

      case PageConst.AccountDetailsScreen:
        return routeBuilder(AccountDetailsScreen());

      case PageConst.EnterPhoneNumberScreen:
        return routeBuilder(EnterPhoneNumberScreen());

      case PageConst.SuccessScreen:
        return routeBuilder(SuccessScreen());

      case PageConst.SetPinScreen:
        return routeBuilder(SetPinScreen());

      case PageConst.EditEmailScreen:
        return routeBuilder(EditEmailScreen());

      case PageConst.SecurityNotificationsScreen:
        return routeBuilder(SecurityNotificationsScreen());

      case PageConst.TwoStepVerificationScreen:
        return routeBuilder(TwoStepVerificationScreen());

      case PageConst.ChangeNumberInfoScreen:
        return routeBuilder(ChangeNumberInfoScreen());

      case PageConst.AccountReportScreen:
        return routeBuilder(AccountReportScreen());

      case PageConst.DeleteAccountScreen:
        return routeBuilder(DeleteAccountScreen());

      case PageConst.LastSeenAndOnlineScreen:
        return routeBuilder(LastSeenAndOnlineScreen());

      case PageConst.ExcludedContactsLastSeenAndOnlineScreen:
        return routeBuilder(ExcludedContactsLastSeenAndOnlineScreen());

      case PageConst.AdvancedPrivacyScreen:
        return routeBuilder(AdvancedPrivacyScreen());

      case PageConst.PrivacyScreen:
        return routeBuilder(PrivacyScreen());

      case PageConst.AppLockGate:
        return routeBuilder(AppLockGate());

      case PageConst.AppLockMainScreen:
        return routeBuilder(AppLockMainScreen());

      case PageConst.AppLockMainScreen:
        return routeBuilder(AppLockMainScreen());

      case PageConst.SelectContactToBlockScreen:
        return routeBuilder(SelectContactToBlockScreen());

      case PageConst.BlockedUsersScreen:
        return routeBuilder(BlockedUsersScreen());

      case PageConst.CameraEffectsListTile:
        return routeBuilder(CameraEffectsListTile());


      case PageConst.PrivacyCallsScreen:
        return routeBuilder(PrivacyCallsScreen());

      case PageConst.ExcludedContactsScreen:
        return routeBuilder(ExcludedContactsScreen());

      case PageConst.GroupPrivacyScreen:
        return routeBuilder(GroupPrivacyScreen());

      case PageConst.ProfileLinksPrivacyScreen:
        return routeBuilder(ProfileLinksPrivacyScreen());

      case PageConst.ExcludedContactsProfilePrivacyScreen:
        return routeBuilder(ExcludedContactsProfilePrivacyScreen());

      case PageConst.ProfilePhotoPrivacyScreen:
        return routeBuilder(ProfilePhotoPrivacyScreen());

      case PageConst.AccountProtectionScreen:
        return routeBuilder(AccountProtectionScreen());

      case PageConst.AddBigPrivacyToYourChats:
        return routeBuilder(AddBigPrivacyToYourChats());

      case PageConst.PrivacySettingsReviewScreen:
        return routeBuilder(PrivacySettingsReviewScreen());

      case PageConst.ControlInMyPrivateInformation:
        return routeBuilder(ControlInMyPrivateInformation());

      case PageConst.ChooseWhoCanContactWithYou:
        return routeBuilder(ChooseWhoCanContactWithYou());

      case PageConst.MyContactsExceptScreen:
        return routeBuilder(ContactsExceptScreen());

      case PageConst.OnlyShareWithScreen:
        return routeBuilder(ShareWithOnlyScreen());

      case PageConst.AboutPrivacyScreen:
        return routeBuilder(AboutPrivacyScreen());

      case PageConst.StatusPrivacyScreen:
        return routeBuilder(StatusPrivacyScreen());

      case PageConst.AutoDisappearMessageTile:
        return routeBuilder(AutoDisappearMessageTile(rightSideText: 'DisappearMessage after 24', onTap: () {  },));


      default:{
        return null;

      }
    }
  }

}
dynamic routeBuilder(Widget child){
  return MaterialPageRoute(builder: (context)=>child);

}
class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page not found "),
      ),
      body: Center(child: Text("Page not found "),),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../../../../constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/vm/get_all_app_contact_viewmodel_provider.dart.dart';
import '../viewmodel/select_contact_controller.dart';
import 'widget/contacts_screan.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({Key? key}) : super(key: key);

  void shareSmsLink(String phoneNumber) async {
    final Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on Lopechat! Download the app at https://synapsechat.com/dl/",
    );
    if (!await launchUrl(sms)) {
      debugPrint('Could not launch SMS app');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double listTilePadding = screenWidth * 0.02;
    final double appBarFontSize = screenWidth * 0.05;

    final contactsState = ref.watch(contactsControllerProvider);




    return Scaffold(
      appBar: AppBar(
        backgroundColor: kkPrimaryColor,
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Contacts',
              style: TextStyle(color: Colors.white, fontSize: appBarFontSize),
            ),

            ]
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search,color: Colors.white,)),
          if (contactsState.status == ContactsLoadStatus.loading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: () {
                ref.read(contactsControllerProvider.notifier).refreshContacts(
                  showMessage: (msg) {
                    AppSnackbar.showError(context, msg);
                  },
                );
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),


        ],
      ),
      body: Builder(builder: (context) {



        final appContacts = contactsState.appContacts;
        final nonAppContacts = contactsState.nonAppContacts;

        return ListView(
          padding: EdgeInsets.symmetric(vertical: listTilePadding),
          children: [
            // مستخدمو التطبيق
            if (appContacts.isNotEmpty) ...[
              ...appContacts.map(
                    (user) => Padding(
                  padding: EdgeInsets.symmetric(vertical: listTilePadding / 2),
                  child: ContactCard(
                    contactSource: user,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.mobileChatScrean,
                        arguments: {
                          'name': user.name,
                          'uid': user.uid,
                          'isGroupChat': false,
                          'profilePic': user.profile,
                        },
                      );
                    },
                  ),
                ),
              ),
           //   const Divider(),
            ],

            // غير مستخدمي التطبيق
            ...nonAppContacts.map(
                  (user) => Padding(
                padding: EdgeInsets.symmetric(vertical: listTilePadding / 2),
                child: ContactCard(
                  contactSource: user,
                  onTap: () => shareSmsLink(user.phoneNumber),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constant.dart';
import '../provider/vm/get_all_app_contact_viewmodel_provider.dart.dart';
import 'widget/contacts_screan.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on WhatsApp! it's a fast, simple, and secure app we can call each other for free. Get it at https://synapsechat.com/dl/",
    );
    if (await launchUrl(sms)) {
      // SMS app opened
    } else {
      // Could not launch SMS app
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    // Responsive font sizes and paddings
    final double appBarTitleFontSize = screenWidth * 0.05; // 5% of screen width
    //final double appBarSubtitleFontSize = screenWidth * 0.03; // 3% of screen width
   // final double listTileFontSize = screenWidth * 0.045; // 4.5% of screen width
    final double listTilePadding = screenWidth * 0.02; // 2% of screen width
    //final double circleAvatarRadius = screenWidth * 0.08; // 8% of screen width
   // final double iconSize = screenWidth * 0.07; // 7% of screen width
    final contactsViewModel = ref.watch(contactsControllerProvider);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: kkPrimaryColor,
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select contact',
              style: TextStyle(color: Colors.white,fontSize: appBarTitleFontSize),
            ),
            const SizedBox(height: 3),
            contactsViewModel.when(
              data: (allContacts) => Text(
                "${allContacts[0].length} contact${allContacts[0].length == 1 ? '' : 's'} on WhatsApp",
                style: TextStyle(fontSize: 14),
              ),
              loading: () => Text('Counting...'),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {
            ElevatedButton(
              onPressed: () {
                ref.read(contactsControllerProvider.notifier).refreshContacts();
              },
              child: Text("Refresh"),
            );

          }, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(contactsControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            itemCount: allContacts[0].length + allContacts[1].length,
            itemBuilder: (context, index) {
              if (index < allContacts[0].length) {
                var firebaseContact = allContacts[0][index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: listTilePadding),
                  child: ContactCard(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.mobileChatScrean,
                        arguments: {
                          'name': firebaseContact.name,
                          'uid': firebaseContact.uid,
                          'isGroupChat': false,
                          'profilePic': firebaseContact.profile,
                        },
                      );
                    },
                      contactSource: firebaseContact,
                  ),
                );
              } else {
                var nonAppContact = allContacts[1][index - allContacts[0].length];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: listTilePadding),
                  child: ContactCard(
                    contactSource: nonAppContact,
                    onTap: () => shareSmsLink(nonAppContact.phoneNumber),
                  ),
                );
              }
            },
          );
        },
        error: (e, t) {
          return Center(child: Text('Error: $e'));
        },
        loading: () {
          return Center(child: CircularProgressIndicator(color: Colors.grey));
        },
      ),
    );
  }
}

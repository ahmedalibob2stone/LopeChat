
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../common/selected_chat.dart';
import '../common/utils/utills.dart';

import '../constant.dart';

import '../features/call/presentation/view/call_list.dart';
import '../features/chat/presentaion/provider/chat_contact/viewmodel/provider.dart';
import '../features/chat/presentaion/provider/chat_group/viewmodel/provider.dart';
import '../features/chat/presentaion/screan/contact_list.dart';
import '../features/status/presentation/screan/status_contacts_screan.dart';
import '../features/user/ui/user_lifecycle_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MobileScreenLayout extends ConsumerStatefulWidget {

  const MobileScreenLayout({Key? key,}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  var searchName = "";
  bool isShowUser = false;
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();
  late final UserLifecycleManager lifecycleManager;

  Set<SelectedChat> selectedChats = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabIndex);
    lifecycleManager = UserLifecycleManager(ref)..init();
  }

  void clearSearch() {
    setState(() {
      searchName = "";
      searchController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabController.removeListener(_handleTabIndex);
    tabController.dispose();
    searchController.dispose();
    lifecycleManager.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lifecycleManager.handleAppLifecycle(state);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  void toggleSelection(String id, bool isGroup) {
    final chat = SelectedChat(id: id, isGroup: isGroup);
    setState(() {
      if (selectedChats.contains(chat)) {
        selectedChats.remove(chat);
      } else {
        selectedChats.add(chat);
      }
    });
  }

  Future<void> archiveSelected() async {
    for (var chat in selectedChats) {
      if (chat.isGroup) {
        await ref.read(GroupArchivingViewModelProvider.notifier)
            .archiveGroup(chat.id);
      } else {
        await ref.read(chatContactViewModelProvider.notifier)
            .archiveChat(chat.id);
      }
    }
    setState(() {
      selectedChats.clear();
    });
    await ref.read(chatContactViewModelProvider.notifier).loadUnarchivedChats();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await ref.read(GroupArchivingViewModelProvider.notifier).loadUnarchivedGroup();
  }

  void clearSelection() {
    setState(() {
      selectedChats.clear();
    });
  }

  File? TackImage;
  File? pickedImage;

  chooseimage() {
    return showDialog(
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("  Photo From ", style: TextStyle(fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                  child: Text("  Camera ", style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: () async {
                    TackImage = await tackImage(context);
                    if (TackImage != null) {
                      Navigator.of(context).pushNamed(PageConst.status, arguments: TackImage);
                    }
                  }
              ),
              SimpleDialogOption(
                child: Text("  Gallery ", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () async {
                  pickedImage = await pickImageFromGallery(context);
                  if (pickedImage != null) {
                    Navigator.of(context).pushNamed(PageConst.status, arguments: pickedImage);
                  }
                },
              ),
              SimpleDialogOption(
                child: Text("  Cancel ", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: kkPrimaryColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 5,
              title: SizedBox(
                height: 40,
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.grey),
                  onChanged: (value) {
                    setState(() {
                      searchName = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    filled: true,
                    fillColor: Color.fromARGB(255, 39, 39, 39),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          clearSearch();
                        },
                      ),
                    ),
                  ),
                  onSubmitted: (String _) {
                    setState(() {
                      isShowUser = true;
                    });
                  },
                ),
              ),
              leading: GestureDetector(
                child: Icon(Icons.menu, color: Colors.white38, size: 30),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              actions: [
                PopupMenuButton(
                  color: Colors.grey,
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Create Group'),
                      onTap: () {
                        Future(() => Navigator.of(context).pushNamed(PageConst.GroupScrean));
                      },
                    )
                  ],
                ),
              ],
              bottom: TabBar(
                controller: tabController,
                indicatorWeight: 4,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'CHATS'),
                  Tab(text: 'STATUS'),
                  Tab(text: 'CALLS'),
                ],
              ),
            ),

            body: TabBarView(
              controller: tabController,
              children: [
                ContactList(
                  searchName: searchName,
                  isShowUser: isShowUser,
                  toggleSelection: toggleSelection, selectedContacts: selectedChats,
                ),
                StatusListScreen(),
                CallListScreen(isGroupChat:true),
              ],
            ),
            floatingActionButton: tabController.index == 0
                ? FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(PageConst.ContactsScrean);
              },
              backgroundColor: kkPrimaryColor,
              child: Icon(Icons.edit_outlined, color: Colors.white, size: MediaQuery.of(context).size.width * 0.07),
            )
                : tabController.index == 1
                ? FloatingActionButton(
              onPressed: () async {
                chooseimage();
              },
              backgroundColor: kkPrimaryColor,
              child: Icon(Icons.camera_alt, color: Colors.white, size: MediaQuery.of(context).size.width * 0.07),
            )
                : Container(),
          );
        } else {
          return Scaffold(

          );
        }
      },
    );
  }
}

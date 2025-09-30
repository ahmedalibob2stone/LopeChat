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
import 'package:firebase_auth/firebase_auth.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  var searchName = "";
  bool isSearching = false; // حالة البحث
  bool isShowUser = true;
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  Set<SelectedChat> selectedChats = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabIndex);

    // لإخفاء البحث عند فقدان التركيز
    searchFocus.addListener(() {

    });
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
    searchFocus.dispose();
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


  void clearSelection() {
    setState(() {
      selectedChats.clear();
    });
  }
  void performSearch(String query) {
    setState(() {
      searchName = query;
      isShowUser = true;
    });
  }
  File? TackImage;
  File? pickedImage;

  chooseimage() {
    return showDialog(
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              "  Photo From ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                  child: Text(
                    "  Camera ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    TackImage = await tackImage(context);
                    if (TackImage != null) {
                      Navigator.of(context)
                          .pushNamed(PageConst.status, arguments: TackImage);
                    }
                  }),
              SimpleDialogOption(
                child: Text(
                  "  Gallery ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  pickedImage = await pickImageFromGallery(context);
                  if (pickedImage != null) {
                    Navigator.of(context)
                        .pushNamed(PageConst.status, arguments: pickedImage);
                  }
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "  Cancel ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: kkPrimaryColor, // لون بار الخلفية الرئيسي
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 5,
            leading: isSearching
                ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchController.clear();
                  searchName = "";
                });
              },
            )
                : IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            ),
            title: isSearching
                ? SizedBox(
              height: 40,
              child:TextField(
                controller: searchController,
                focusNode: searchFocus,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                  onChanged:(value) {
                    performSearch(value);
                  },
                onSubmitted: (value) {
                  performSearch(value);
                  FocusScope.of(context).unfocus(); // يخفي الكيبورد لكن يبقي البحث
                },

                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black45,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  suffixIcon: Icon(Icons.search, color: Colors.white70),
                    prefixIcon : IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        searchController.clear();
                        searchName = "";
                      });
                    },
                  ),
                ),
              ),
            )
                : Text(
              "LopeChat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              if (!isSearching)
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white, size: 28),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
              PopupMenuButton(
                color: Colors.grey[800],
                icon: Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Create Group', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Future(() => Navigator.of(context).pushNamed(PageConst.GroupScrean));
                    },
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'CHATS'),
                Tab(text: 'STATUS'),
                Tab(text: 'CALLS'),
              ],
            ),
          )
          ,
          body: TabBarView(
            controller: tabController,
            children: [
              ContactList(
                searchName: searchName,
                isShowUser: isShowUser,
                toggleSelection: toggleSelection,
                selectedContacts: selectedChats,
              ),
              StatusListScreen(),
              CallListScreen(isGroupChat: true),
            ],
          ),
          floatingActionButton: tabController.index == 0
              ? FloatingActionButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(PageConst.ContactsScrean);
            },
            backgroundColor: kkPrimaryColor,
            child: Icon(Icons.edit_outlined,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.07),
          )
              : tabController.index == 1
              ? FloatingActionButton(
            onPressed: () async {
              chooseimage();
            },
            backgroundColor: kkPrimaryColor,
            child: Icon(Icons.camera_alt,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.07),
          )
              : Container(),
        );
      },
    );
  }
}

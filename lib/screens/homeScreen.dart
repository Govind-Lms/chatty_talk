import 'package:chaty_talk/enum/user_state.dart';
import 'package:chaty_talk/firebase/auth_methods.dart';
import 'package:chaty_talk/firebase/local_db/repository/log_repository.dart';
import 'package:chaty_talk/provider/user_provider.dart';
import 'package:chaty_talk/screens/callScreens/pickUp/pickup_layout.dart';
import 'package:chaty_talk/screens/pageViews/logs/log_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  UserProvider userProvider;
  int _page= 0;
  AuthMethods _authMethods= AuthMethods();

  
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                uid: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                uid: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                uid: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                uid: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context,listen: false);
      await userProvider.refreshUser();
      _authMethods.setUserState(uid: userProvider.getUser.uid, userState: UserState.Online);
      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );

    });
    WidgetsBinding.instance.addObserver(this);
    pageController= PageController();
  }


  void navigationTab(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: [
            ChatListScreen(),
            LogScreen(),
            // Center(child: Text('Call Logs',style: TextStyle(color: Colors.white),)),
            Center(child: Text('Contact Screens',style: TextStyle(color: Colors.white),)),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CupertinoTabBar(
            backgroundColor: UniversalVariables.blackColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,color: (_page == 0 ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),),
                // ignore: deprecated_member_use
                title: Text('Chats',style: TextStyle(fontSize: 10.0,color:(_page == 0 ? UniversalVariables.lightBlueColor : Colors.grey),),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call,color: (_page == 1 ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),),
                // ignore: deprecated_member_use
                title: Text('Calls',style: TextStyle(fontSize: 10.0,color:(_page == 1 ? UniversalVariables.lightBlueColor : Colors.grey),),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts,color: (_page == 2 ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),),
                // ignore: deprecated_member_use
                title: Text('Contacts',style: TextStyle(fontSize: 10.0,color:(_page == 2 ? UniversalVariables.lightBlueColor : Colors.grey),),),
              ),
            ],
            onTap: navigationTab,

          ),
        ),
      ),
    );
  }
}
import 'package:chaty_talk/screens/callScreens/pickUp/pickup_layout.dart';
import 'package:chaty_talk/screens/pageViews/logs/widgets/logListContainer.dart';
import 'package:chaty_talk/utils/universal_variables.dart';
import 'package:chaty_talk/widgets/skype_app_bar.dart';
import 'package:flutter/material.dart';

import 'widgets/floatingColumn.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          actions: [
            IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: (){
              Navigator.of(context).pushNamed('search_screen');
            }),
          ],
          title: 'Calls',
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
import 'package:chaty_talk/firebase/callMethods.dart';
import 'package:chaty_talk/models/call.dart';
import 'package:chaty_talk/provider/user_provider.dart';
import 'package:chaty_talk/screens/callScreens/pickUp/pickup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {

  final Widget scaffold;
  final CallMethods callMethods= CallMethods();

  PickupLayout({Key key, this.scaffold}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider= Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                CallModel callModel = CallModel.formMap(snapshot.data.data);

                if (!callModel.hasDialled) {
                  return PickupScreen(callModel: callModel);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

import 'package:chaty_talk/firebase/auth_methods.dart';
import 'package:chaty_talk/firebase/chat_methods.dart';
import 'package:chaty_talk/models/contact.dart';
import 'package:chaty_talk/provider/user_provider.dart';
import 'package:chaty_talk/screens/pageViews/pageView_widgets/pageView_widgets.dart';
import 'package:chaty_talk/widgets/online_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens.dart';

class ContactView extends StatelessWidget {
  final ContactModel contactModel;
  final AuthMethods authMethods = AuthMethods();

  ContactView(this.contactModel);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: authMethods.getUserDetailsById(contactModel.uid),
      builder: (context,snapshot){
        if(snapshot.hasData){
          UserModel userModel = snapshot.data;

          return ViewLayout(contactUserModel: userModel,);
        }
        return Container();
      },
    );
  }
}

class ViewLayout extends StatelessWidget {

  final UserModel contactUserModel;
  final ChatMethods chatMethods = ChatMethods();
  ViewLayout({this.contactUserModel});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider= Provider.of<UserProvider>(context);
    return CustomTile(
      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatsScreen(receiverUserModel: contactUserModel,))),
      mini: false,
      /// ?. is conditional member(access operator) is also equals to the below one
      /// contact!= null ? contact.name : null
      /// 
      /// ?? is if-null operator
      title: Text(contactUserModel?.name  ?? "Invalid" ,style: TextStyle(color: Colors.white,fontFamily: "Arial"),),
      subtitle: LastMessageContainer(
        stream: chatMethods.fetchLastMessageBetween(senderId: userProvider.getUser.uid, receiverId: contactUserModel.uid),
      ),
      leading: Container(
        margin: EdgeInsets.all(5.0),
        constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
        child: Stack(
          children: [
            CachedImage(
              imageUrl: contactUserModel.profilePhoto,
              fit: BoxFit.cover,
              isRound: true,
              radius: 55.0,
            ),
            OnlineDotIndicator(
              uid: contactUserModel.uid,
            )
          ],
        ),
      ),
    );
  }
}
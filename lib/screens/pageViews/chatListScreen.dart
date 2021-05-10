import 'package:chaty_talk/firebase/chat_methods.dart';
import 'package:chaty_talk/models/contact.dart';
import 'package:chaty_talk/provider/user_provider.dart';
import 'package:chaty_talk/screens/pageViews/pageView_widgets/contact_view.dart';
import 'package:chaty_talk/screens/pageViews/pageView_widgets/pageView_widgets.dart';
import 'package:chaty_talk/widgets/skype_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';

class ChatListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: SkypeAppBar(
        actions: [
          IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: (){
            Navigator.of(context).pushNamed('search_screen');
          }),
          IconButton(icon: Icon(Icons.more_vert,color: Colors.white,), onPressed: (){}),
        ],
        title: UserCircle(),
      ),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods chatMethods = ChatMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider= Provider.of<UserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: chatMethods.fetchContacts(userId: userProvider.getUser.uid),

      builder: (context, snapshot) {
        if(snapshot.hasData){
          var docList= snapshot.data.documents;
          if(docList.isEmpty){
            return QuietBox(
              heading: 'Are You Lost?',
              subtitle: 'Search for your friends and family to start chatting!',
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: docList.length,
            itemBuilder: (context, index){
              ContactModel contactModel = ContactModel.formMap(docList[index].data);
              return ContactView(contactModel);
            },
          );
        }
        return Center(child:CircularProgressIndicator());
      }
    );
  }
}


import 'dart:io';
import 'package:chaty_talk/enum/view_state.dart';
import 'package:chaty_talk/firebase/auth_methods.dart';
import 'package:chaty_talk/firebase/chat_methods.dart';
import 'package:chaty_talk/firebase/storage_methods.dart';
import 'package:chaty_talk/provider/image_upload_provider.dart';
import 'package:chaty_talk/screens/callScreens/pickUp/pickup_layout.dart';
import 'package:chaty_talk/utils/call_utils.dart';
import 'package:chaty_talk/utils/permissions.dart';
import 'package:chaty_talk/widgets/cachedImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatsScreen extends StatefulWidget {
  final UserModel receiverUserModel;

  const ChatsScreen({Key key, this.receiverUserModel}) : super(key: key);
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController textEditingController= TextEditingController();
  ChatMethods chatMethods= ChatMethods();
  StorageMethods storageMethods = StorageMethods();
  AuthMethods authMethods= AuthMethods();
  UserModel senderUserModel;
  String _currentUserId;
  bool isWriting= false;
  bool showEmojiPicker= false;
  ScrollController listScrollControlller= ScrollController();
  FocusNode textFieldFocus= FocusNode();
  ImageUploadProvider imageUploadProvider;

  CustomAppBar customAppBar (context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,),
        onPressed: (){Navigator.of(context).pop();},
      ),
      centerTitle: false,
      title: Text(widget.receiverUserModel.name),
      actions: [
        IconButton(
          icon: Icon(Icons.video_call,),
          onPressed: () async=>  
            await Permissions.cameraAndMicrophonePermissionsGranted()
              ? CallUtils.dial(from: senderUserModel,to: widget.receiverUserModel,context: context) 
              : {}
          
        ),
        IconButton(
          icon: Icon(Icons.phone,),
          onPressed: (){
          },
        ),
      ],
    );
  }

  Widget messageList(){
    return StreamBuilder(
      stream: Firestore.instance.collection('messages').document(_currentUserId).collection(widget.receiverUserModel.uid).orderBy('timestamp',descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
        // ignore: unrelated_type_equality_checks
        if(snapshot.data == null){
          return Container(
            child: Column(
              children: [
                SizedBox(height: 20.0,),
                Icon(Icons.chat_bubble_sharp,color: Colors.white,),
                SizedBox(height: 10.0,),
                Text('No Chats',style: TextStyle(color: Colors.white,),),
              ],
            ),
          );
        }
        /// scroll to bottom whenever a new message comes out or when u start to type a new message
        SchedulerBinding.instance.addPostFrameCallback((_) {
          listScrollControlller.animateTo(
            listScrollControlller.position.minScrollExtent, 
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        });

        return ListView.builder(
          controller: listScrollControlller,
          reverse: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot){
    Message message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        alignment: message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: message.senderId == _currentUserId
            ? senderLayout(message)
            : receiverLayout(message),
      ),
    );
  }

  Widget senderLayout(Message message){
    Radius messageRadius = Radius.circular(15.0);
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width* 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          bottomLeft: messageRadius,
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: getMessage(message),
      ),
    );
  }
  
  Widget receiverLayout(Message message){
    Radius messageRadius = Radius.circular(15.0);
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.greyColor,
        borderRadius: BorderRadius.only(
          topRight: messageRadius,
          bottomRight: messageRadius,
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: getMessage(message),
      ),
    );
  }
  
  sendMessage() {
    var text = textEditingController.text;

    Message message = Message(
      receiverId: widget.receiverUserModel.uid,
      senderId: senderUserModel.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    textEditingController.text = "";
    chatMethods.addMessageToDB(message);
  }
  
  getMessage(Message message) {
    return message.type != 'image'
        ? Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    )
        : message.photoUrl != null
        ? CachedImage(
      imageUrl: message.photoUrl,
      height: 150,
      width: 150,
      radius: 10,
    ) : Text("Url is null");
  }

  Widget chatControls(){
    setWritingTo(bool val){
      setState(() {
        isWriting= val;
      });
    }
    addMediaModal(context){
      showModalBottomSheet(
        context: context,
        elevation: 0.0,
        // backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(color:UniversalVariables.blackColor ,borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      // ignore: deprecated_member_use
                      FlatButton(onPressed: (){Navigator.maybePop(context);}, child: Icon(Icons.close)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Content & Tools',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(child: ListView(
                  children: [
                    ModalTile(title: 'Media', subtitle: "Share Photos and Video", icon: Icons.image,onTap: ()=> pickImage(source: ImageSource.gallery)),
                    ModalTile(title: 'Files', subtitle: "Share Files and Documents", icon: Icons.tab),
                    ModalTile(title: 'Contact', subtitle: "Share Your Contacts Info", icon: Icons.perm_contact_cal_sharp),
                    ModalTile(title: 'Location', subtitle: "Share Your Location", icon: Icons.add_location),
                    ModalTile(title: 'Schedule', subtitle: "Arrange A Call Schedule", icon: Icons.schedule),
                    ModalTile(title: 'Create Poll', subtitle: "Share Polls", icon: Icons.poll),

                  ],
                ))
              ],
            ),
          );
        }
      );
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              addMediaModal(context);
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 5.0,),
          Expanded(
            child: Stack(
              children: 
                [TextField(
                  onTap: (){
                    hideEmojiContainder();
                  },
                  focusNode: textFieldFocus,
                  autofocus: false,
                  controller: textEditingController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val){
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Aa..",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                    fillColor: UniversalVariables.separatorColor,
                    filled: true,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: (){
                      if(!showEmojiPicker){
                        hideKeyboard();
                        showEmojiContainder();
                      }
                      else{
                        showKeyboard();
                        hideEmojiContainder();
                      }
                    },
                    icon: Icon(Icons.emoji_emotions_rounded),
                  ),
                )
              ],
            ),
          ),
          isWriting ? Container() :
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.record_voice_over),
          ),
          isWriting ? Container()
               : 
            GestureDetector(
              onTap: (){
                pickImage(source: ImageSource.camera);
              },
              child: Icon(Icons.camera_alt)),
          isWriting ? Container(
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send,color: Colors.white,),
              onPressed: (){
                sendMessage();
              },
            ),
          ) : Container()
        ],
      ),
    );
  }
  // ignore: invalid_required_positional_param
  Future pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    storageMethods.uploadImage(
      image: selectedImage,
      receiverId: widget.receiverUserModel.uid,
      senderId: senderUserModel.uid,
      imageUploadProvider: imageUploadProvider,
    );
  }
  
  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 6,
      columns: 8,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        textEditingController.text = textEditingController.text + emoji.emoji;
      },
      // recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 10,
    );
  }
  
  showKeyboard()=> textFieldFocus.requestFocus();
  
  hideKeyboard()=> textFieldFocus.unfocus();

  showEmojiContainder(){
    setState(() {
        showEmojiPicker= true;
    });
  }

  hideEmojiContainder(){
    setState(() {
        showEmojiPicker= false;
    });
  }

  @override
  void initState() {
    super.initState();
    authMethods.getCurrentUser().then((user){
      _currentUserId = user.uid;
      setState(() {
        senderUserModel= UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
          email: user.email,
        );
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Container(
          // margin: EdgeInsets.only(left: 10.0,right: 10.0),
          child: Column(
            children: [
              // RaisedButton(
              //   child: Text('Change View State'),
              //   onPressed: (){
              //     imageUploadProvider.getViewState== ViewState.LOADING ? imageUploadProvider.setToIdle() : imageUploadProvider.setToLoading();
              //   },
              // ),
              
              Flexible(
                child: messageList(),
              ),
              imageUploadProvider.getViewState == ViewState.LOADING 
                ? Container(
                  width: 150.0,
                  height: 150.0,
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width* 0.45),
                  decoration: BoxDecoration(
                    color: UniversalVariables.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    )
                  ),
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator()
                )
                : Container(),
              chatControls(),
              showEmojiPicker ? Container(child: emojiContainer(),) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 25,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
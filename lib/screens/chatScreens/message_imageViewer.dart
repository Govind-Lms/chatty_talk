import 'package:chaty_talk/widgets/cachedImage.dart';
import 'package:flutter/material.dart';

class MessageImageViewer extends StatelessWidget {
  final String url;

  const MessageImageViewer({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ChatsScreen())),
        child: Container(
          child: CachedImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            isRound: false,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
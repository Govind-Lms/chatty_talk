import 'package:chaty_talk/firebase/auth_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens.dart';

// ignore: must_be_immutable
class NewChatButton extends StatelessWidget {
  AuthMethods repo= AuthMethods();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: (){
      //   repo.signOut();
      //   Navigator.of(context).pushReplacementNamed('login');
      // },
      child: Container(
        decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.edit,color: Colors.white,size: 25.0,),
        padding: EdgeInsets.all(12.0),
      ),
    );
  }
}
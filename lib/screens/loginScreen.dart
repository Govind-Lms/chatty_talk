import 'package:chaty_talk/firebase/auth_methods.dart';

import 'screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  AuthMethods repo=  AuthMethods();

  bool _isLoginPressed= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loginButton(),
          SizedBox(height: 10.0,),
          _isLoginPressed ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }
  Widget loginButton(){
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      // ignore: deprecated_member_use
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding:  EdgeInsets.all(15),
        child: Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
        onPressed: () {
          perfomLogin();
        }
      ),
    );
  }
  void perfomLogin(){
    setState(() {
      _isLoginPressed = true;
    });
    repo.signInWithGoogle().then((FirebaseUser user){
      if(user!= null){
        authenticateUser(user);
      }
      else{
        print("there was an error");
      }
    });
  }
  void authenticateUser(FirebaseUser user){
    repo.authenticateUser(user).then((isNewUser){
      setState(() {
        _isLoginPressed= false;
      });
      if(isNewUser){
        repo.addDataToDb(user).then((value){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
      });
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
      }
    });
  }
}
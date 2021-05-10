import 'package:chaty_talk/firebase/auth_methods.dart';
import 'package:chaty_talk/models/user.dart';
import 'package:chaty_talk/screens/screens.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier{
  UserModel userModel;
  AuthMethods authMethods= AuthMethods();

  UserModel get getUser=> userModel;
  Future<void> refreshUser() async{
    UserModel _userModel= await authMethods.getUserDetails();
    userModel= _userModel;
    notifyListeners();

  }
}
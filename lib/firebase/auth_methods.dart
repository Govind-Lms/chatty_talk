

import 'package:chaty_talk/enum/user_state.dart';
import 'package:chaty_talk/models/token.dart';
import 'package:chaty_talk/models/user.dart';
import 'package:chaty_talk/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final CollectionReference userCollection= Firestore.instance.collection('users');
  final CollectionReference messageCollection= Firestore.instance.collection('messages');
  StorageReference storageReference ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseMessaging fcm= FirebaseMessaging();
///
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<UserModel> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await userCollection.document(currentUser.uid).get();
    return UserModel.fromMap(documentSnapshot.data);
  }

  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =await userCollection.document(id).get();
      
      final fcmToken= await fcm.getToken();

      TokenModel tokenModel= TokenModel(
        token: fcmToken,
        createAt: Timestamp.now(),
      );
      await userCollection
        .document(id)
        .collection('tokens')
        .document(fcmToken)
        .setData(tokenModel.toMap(tokenModel));
      return UserModel.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
///
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      FirebaseUser user = await _auth.signInWithCredential(credential);
      return user;
    } catch (e) {
      print("Auth methods error");
      print(e);
      return null;
    }
  }
///
  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await userCollection
        .where('email', isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUserName(currentUser.email);

    UserModel userModel = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    userCollection.document(currentUser.uid).setData(userModel.toMap(userModel));
  }

  Future<List<UserModel>> fetchAllUsers(FirebaseUser currentUser) async {
    // ignore: deprecated_member_use
    List<UserModel> userList = List<UserModel>();

    QuerySnapshot querySnapshot =
        await userCollection.getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(UserModel.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void setUserState({@required String uid, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    userCollection.document(uid).updateData({
      'state': stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      userCollection.document(uid).snapshots();
}

// import 'dart:io';

// import 'package:chaty_talk/enum/user_state.dart';
// import 'package:chaty_talk/models/contact.dart';
// import 'package:chaty_talk/models/message.dart';
// import 'package:chaty_talk/models/user.dart';
// import 'package:chaty_talk/provider/image_upload_provider.dart';
// import 'package:chaty_talk/utils/utilities.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';


// class FirebaseMethods{
//   final CollectionReference userCollection= Firestore.instance.collection('users');
//   final CollectionReference messageCollection= Firestore.instance.collection('messages');
//   StorageReference storageReference ;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<FirebaseUser>getCurrentUser() async {
//     FirebaseUser currentUser;
//     currentUser = await _auth.currentUser();
//     return currentUser;
//   }
//   Future<FirebaseUser> signInWitGoogle() async {
//     try {
//       GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
//       GoogleSignInAuthentication _signInAuthentication =
//       await _signInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.getCredential(
//           accessToken: _signInAuthentication.accessToken,
//           idToken: _signInAuthentication.idToken);

//       FirebaseUser user = await _auth.signInWithCredential(credential);
//       return user;
//     } catch (e) {
//       print("Auth methods error");
//       print(e);
//       return null;
//     }
//   }
//   Future<void> signOut()async{
//     await _googleSignIn.disconnect();
//     await _googleSignIn.signOut();
//     return _auth.signOut();
//   }

//   Future<bool>authenticateUser (FirebaseUser user)async{
//     QuerySnapshot querySnapshot= await Firestore.instance
//       .collection('users').where("email",isEqualTo: user.email)
//       .getDocuments();
//     final List<DocumentSnapshot> docs= querySnapshot.documents;
//     return docs.length==0 ? true : false;
//   }
//   Future<FirebaseUser> signInWithGoogle() async {
//     GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
//     GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);

//     FirebaseUser result = await _auth.signInWithCredential(credential);
//     return result;
//   }
//   Future<List<UserModel>> fetchAllUsers(FirebaseUser user) async{
//     List<UserModel> userList = <UserModel>[];
//     QuerySnapshot querySnapshot= await Firestore.instance.collection('users').getDocuments();
//     for(var i = 0; i< querySnapshot.documents.length;i++){
//       if(querySnapshot.documents[i].documentID != user.uid){
//         userList.add(UserModel.fromMap(querySnapshot.documents[i].data));
//       }
//     }
//     return userList;
//   }
//   Future<UserModel> getUserDetails()async{
//     FirebaseUser currentUser= await getCurrentUser();
//     DocumentSnapshot documentSnapshot =  await userCollection.document(currentUser.displayName).get();
//     return UserModel.fromMap(documentSnapshot.data);
//   }
//   Future<UserModel> getUserDetailsById(id)async{
//     try{
//       DocumentSnapshot documentSnapshot =  await userCollection.document(id).get();
//       return UserModel.fromMap(documentSnapshot.data);
//     }catch(e){
//       print(e);
//       return e;
//     }
//   }
//   void setUserState({@required String userId, @required UserState userState }){
//     int stateNum = Utils.stateToNum(userState);
//     userCollection.document(userId).updateData({
//       "state": stateNum,
//     });
//   }
//   Stream <DocumentSnapshot> getUserStream({@required String uid}) =>
//     userCollection.document(uid).snapshots();

//   Future<void> addDataToDb(FirebaseUser currentUser) async {
//     String username = Utils.getUserName(currentUser.email);
//     UserModel user= UserModel(
//         uid: currentUser.uid,
//         email: currentUser.email,
//         name: currentUser.displayName,
//         profilePhoto: currentUser.photoUrl,
//         username: username,
//     );
//     Firestore.instance
//         .collection('users')
//         .document(currentUser.displayName)
//         .setData(user.toMap(user));
//   }
  
//   ///
//   ///
//   Future<void>addMessageToDB(Message message, UserModel sender, UserModel receiver) async{
//     var map= message.toMap();
//     await messageCollection
//         .document(message.senderId)
//         .collection(message.receiverId)
//         .add(map);
//     addToContacts(senderId: message.senderId, receiverId: message.receiverId);
//     print(message.senderId);
//     print(message.receiverId);
//     return await messageCollection
//         .document(message.receiverId)
//         .collection(message.senderId)
//         .add(map);
//   }
 
//   ///
//   ///
//   DocumentReference getContactsDocument({String of, String forContacts})=>
//     userCollection.document(of).collection('contacts').document(forContacts);

//   addToContacts({String url, String receiverId, String senderId}) async{
//     Timestamp currentTime= Timestamp.now();
//     await addToSenderContacts(senderId, receiverId,currentTime);
//     await addToReceiverContacts(senderId, receiverId,currentTime);
//   }
//   Future<void> addToSenderContacts(String senderId, String receiverId, currentTime )async{
//     DocumentSnapshot senderSnapshot=  await getContactsDocument(of: senderId,forContacts: receiverId).get();
    
//     if(!senderSnapshot.exists){
//       ContactModel receiverContact= ContactModel(
//         addedOn: currentTime,
//         uid: receiverId,
//       );
//       var receiverMap= receiverContact.toMap(receiverContact);
//       await getContactsDocument(of: senderId, forContacts: receiverId).setData(receiverMap);
//     }
//   }
//   Future<void> addToReceiverContacts(String senderId, String receiverId, currentTime )async{
//     DocumentSnapshot receiverSnapshot=  await getContactsDocument(of: receiverId,forContacts: senderId).get();
    
//     if(!receiverSnapshot.exists){
//       ContactModel senderContact= ContactModel(
//         addedOn: currentTime,
//         uid: receiverId,
//       );
//       var senderMap =  senderContact.toMap(senderContact);
//       await getContactsDocument(of: receiverId, forContacts: senderId).setData(senderMap);
//     }
//   }
//   Stream<QuerySnapshot> fetchContacts({String uid})=>
//     userCollection.document(uid).collection('contacts').snapshots();
//   Stream<QuerySnapshot> fetchLastMessageBetween({@required senderId, @required receiverId})=>
//     messageCollection.document(senderId).collection(receiverId).orderBy('timestamp').snapshots();
  
//   ///
//   ///
//   Future<String> uploadImageToStorage(File image) async {
//     try {
//       storageReference= FirebaseStorage.instance.ref().child(
//         '${DateTime.now().millisecondsSinceEpoch}'
//       );
//       StorageUploadTask task = storageReference.putFile(image);
//       var url = await(await task.onComplete).ref.getDownloadURL();
//       print(url);
//       return url;
//     } 
//     catch(e){
//       print(e);
//       return null;
//     }
//   }
  
//   void setImageMessage(String url, String receiverId, String senderId) async{
//     Message message;
//     message= Message.imageMessage(
//       message: "IMAGE",
//       photoUrl: url,
//       receiverId: receiverId,
//       senderId: senderId,
//       timestamp: Timestamp.now(),
//       type: 'image',
//     );
//     var map= message.toImageMap();
//     //set data to FIRESTORE
//     await Firestore.instance
//         .collection('messages')
//         .document(message.senderId)
//         .collection(message.receiverId)
//         .add(map);
//     await Firestore.instance.collection('messages')
//         .document(message.receiverId)
//         .collection(message.senderId)
//         .add(map);
//   }

//   void uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageUploadProvider) async{
    
//     imageUploadProvider.setToLoading();
//     String url = await uploadImageToStorage(image);
//     imageUploadProvider.setToIdle();
//     setImageMessage(url, receiverId, senderId);

//   }
// }

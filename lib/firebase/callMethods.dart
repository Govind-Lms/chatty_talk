import 'package:chaty_talk/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods{

  final CollectionReference callCollection= Firestore.instance.collection('calls');

  Stream<DocumentSnapshot> callStream({String uid})=> callCollection.document(uid).snapshots();

  Future<bool> makeCall({CallModel callModel}) async {
    try {
      callModel.hasDialled= true;
      Map<String, dynamic> hasDialledMap= callModel.toMap(callModel);
      
      callModel.hasDialled= false;
      Map<String, dynamic> hasNotDialledMap= callModel.toMap(callModel);
      
      await callCollection.document(callModel.callerId).setData(hasDialledMap);
      await callCollection.document(callModel.receiverId).setData(hasNotDialledMap);

      return true;
    } catch (e) {
      print(e);
      return false;
    }

  }
  Future<bool> endCall({CallModel callModel}) async{
    try {
      await  callCollection.document(callModel.callerId).delete();
      await  callCollection.document(callModel.receiverId).delete();
      return true;
    }catch (e) {
      print(e);
      return false;
    }
    
  }

}


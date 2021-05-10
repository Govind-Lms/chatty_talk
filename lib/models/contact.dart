import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel{
  Timestamp addedOn;
  String uid;

  ContactModel({
    this.uid,
    this.addedOn,
  });

  Map toMap(ContactModel contactModel){
    var map= Map<String,dynamic>();
    map['uid'] = this.uid;
    map['addedOn'] = this.addedOn;
    return map;
  }


  ContactModel.formMap(Map callMap){
    this.uid = callMap['uid'];
    this.addedOn = callMap['addedOn'];
    
  }

}
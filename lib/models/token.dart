import 'package:cloud_firestore/cloud_firestore.dart';

class TokenModel{
  String token;
  Timestamp createAt;
  TokenModel({this.token,this.createAt});
  
  
  
  Map toMap(TokenModel contactModel){
    var map= Map<String,dynamic>();
    map['token'] = this.token;
    map['createAt'] = this.createAt;
    return map;
  }


  TokenModel.formMap(Map tokenMap){
    this.token = tokenMap['tokem'];
    this.createAt = tokenMap['createAt'];
    
  }
}
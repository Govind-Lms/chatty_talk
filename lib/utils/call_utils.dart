import 'dart:math';

import 'package:chaty_talk/constants/strings.dart';
import 'package:chaty_talk/firebase/callMethods.dart';
import 'package:chaty_talk/firebase/local_db/repository/log_repository.dart';
import 'package:chaty_talk/models/call.dart';
import 'package:chaty_talk/models/log.dart';
import 'package:chaty_talk/models/user.dart';
import 'package:chaty_talk/screens/callScreens/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils{
  static final CallMethods callMethods = CallMethods();


  static dial({  UserModel from,UserModel to, context }) async{

    
    CallModel callModel = CallModel(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      channelId: Random().nextInt(10000).toString(),
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
    );

    LogModel logModel= LogModel(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );


    bool callMade= await callMethods.makeCall(callModel:  callModel);
    callModel.hasDialled=  true;
    if(callMade){
      //add calls to local db
      LogRepository.addLog(logModel);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CallScreen(callModel:  callModel,)));

    }
  }
}
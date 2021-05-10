import 'package:chaty_talk/constants/strings.dart';
import 'package:chaty_talk/firebase/callMethods.dart';
import 'package:chaty_talk/firebase/local_db/repository/log_repository.dart';
import 'package:chaty_talk/models/call.dart';
import 'package:chaty_talk/models/log.dart';
import 'package:chaty_talk/screens/callScreens/call_screen.dart';
import 'package:chaty_talk/utils/permissions.dart';
import 'package:chaty_talk/widgets/cachedImage.dart';
import 'package:flutter/material.dart';


class PickupScreen extends StatefulWidget {

  final CallModel callModel;

  PickupScreen({this.callModel});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed= true;
  
  
  
  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  //initializes and add logs to db
  addToLocalStorage({@required String callStatus}) {
    LogModel logModel = LogModel(
      callerName: widget.callModel.callerName,
      callerPic: widget.callModel.callerPic,
      receiverName: widget.callModel.receiverName,
      receiverPic: widget.callModel.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLog(logModel);
  }


  @override
  Widget build(BuildContext context) {
    // final String imageUrl;
    // final bool isRound;
    // final double radius;
    // final double height;
    // final double width;
    return Scaffold(
      body: Container(alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming...',style: TextStyle(fontSize: 30.0),),
            SizedBox(height: 50.0,),
            CachedImage(
              imageUrl: widget.callModel.callerPic,
              // isRound: true,
              radius: 12.0,
              height: 150.0,
              width: 150.0,
            ),
            SizedBox(height: 15.0,),
            Text(widget.callModel.callerName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
            SizedBox(height: 75.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(callModel: widget.callModel);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(callModel: widget.callModel,),
                              ),
                            )
                          // ignore: unnecessary_statements
                          : {};
                    }),
              ],
            ),
          ],
        )
      ),
    );
  }
}
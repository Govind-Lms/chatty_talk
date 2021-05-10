class LogModel{
  int logId;
  String callerName;
  String callerPic;
  String receiverName;
  String receiverPic;
  String callStatus;
  String timestamp;

  LogModel({
    this.logId,
    this.callerName,
    this.callerPic,
    this.receiverName,
    this.receiverPic,
    this.callStatus,
    this.timestamp
  });


  Map<String,dynamic> toMap(LogModel logModel){
    Map<String, dynamic> logMap= Map();
    logMap['logId'] = logModel.logId;
    logMap['callerName'] = logModel.callerName;
    logMap['callerPic'] = logModel.callerPic;
    logMap['receiverName'] = logModel.receiverName;
    logMap['receiverPic'] = logModel.receiverPic;
    logMap['callStatus'] = logModel.callStatus;
    logMap['timestamp'] = logModel.timestamp;
    return logMap;
  }
  LogModel.fromMap(Map logMap){
    this.logId=  logMap['logId'];
    this.callerName=  logMap['callerName'];
    this.callerPic=  logMap['callerPic'];
    this.receiverName=  logMap['receiverName'];
    this.receiverPic=  logMap['receiverPic'];
    this.callStatus=  logMap['callStatus'];
    this.timestamp=  logMap['timestamp'];
    
  }
}

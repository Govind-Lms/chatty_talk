class CallModel {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;

  bool hasDialled;
  
  CallModel({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled,
  });

  Map<String, dynamic> toMap(CallModel callModel){
    Map<String, dynamic> callMap = Map();
    callMap['caller_id'] = callModel.callerId;
    callMap['caller_name'] = callModel.callerName;
    callMap['caller_pic'] = callModel.callerPic;
    callMap['receiver_id'] = callModel.receiverId;
    callMap['receiver_name'] = callModel.receiverName;
    callMap['receiver_pic'] = callModel.receiverPic;
    callMap['channel_id'] = callModel.channelId;
    callMap['has_dialled'] = callModel.hasDialled;
    return callMap;
  }

  CallModel.formMap(Map callMap){
    this.callerId = callMap['caller_id'];
    this.callerName = callMap['caller_name'];
    this.callerPic = callMap['caller_pic'];
    this.receiverId = callMap['receiver_id'];
    this.receiverName = callMap['receiver_name'];
    this.receiverPic = callMap['receiver_pic'];
    this.channelId = callMap['channel_id'];
    this.hasDialled = callMap['has_dialled'];
    
  }
}

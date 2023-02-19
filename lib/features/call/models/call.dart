class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final bool hasDialled;
  final String callId;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.hasDialled,
    required this.callId,
  });

  Call.fromJson(Map<String, dynamic> json)
      : callerId = json['callerId'],
        callerName = json['callerName'],
        callerPic = json['callerPic'],
        receiverId = json['receiverId'],
        receiverName = json['receiverName'],
        receiverPic = json['receiverPic'],
        hasDialled = json['hasDialled'],
        callId = json['callId'];

  Map<String, dynamic> toJson() => {
        'callerId': callerId,
        'callerName': callerName,
        'callerPic': callerPic,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'receiverPic': receiverPic,
        'hasDialled': hasDialled,
        'callId': callId,
      };
}

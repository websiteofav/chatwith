class GroupModel {
  final String name;
  final String lastUserUid;
  final String groupProfilePic;

  final String groupUid;
  final String lastMessage;
  final DateTime lastMessageTime;

  final List<String> membersUid;

  GroupModel({
    required this.name,
    required this.lastUserUid,
    required this.groupProfilePic,
    required this.groupUid,
    required this.lastMessage,
    required this.membersUid,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastUserUid': lastUserUid,
      'groupProfilePic': groupProfilePic,
      'groupUid': groupUid,
      'lastMessage': lastMessage,
      'membersUid': membersUid,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      name: json['name'],
      lastUserUid: json['lastUserUid'],
      groupProfilePic: json['groupProfilePic'],
      groupUid: json['groupUid'],
      lastMessage: json['lastMessage'],
      membersUid: List<String>.from(
        json['membersUid'],
      ),
      lastMessageTime: json['lastMessageTime'].toDate(),
    );
  }
}

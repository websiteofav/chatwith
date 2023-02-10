class ContactChat {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String recentMessage;

  ContactChat(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.timeSent,
      required this.recentMessage});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contactId': contactId,
      'timeSent': timeSent,
      'profilePic': profilePic,
      'recentMessage': recentMessage,
    };
  }

  factory ContactChat.fromJson(Map<String, dynamic> json) {
    return ContactChat(
      name: json['name'],
      contactId: json['contactId'],
      timeSent: json['timeSent'].toDate(),
      profilePic: json['profilePic'],
      recentMessage: json['recentMessage'],
    );
  }
}

class Status {
  final String uid;
  final String username;
  final String mobileNumber;
  final List<String> imageUrls;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> inContactUser;

  Status({
    required this.uid,
    required this.username,
    required this.mobileNumber,
    required this.imageUrls,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.inContactUser,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      uid: json['uid'],
      username: json['username'],
      mobileNumber: json['mobileNumber'],
      imageUrls: List<String>.from(json['imageUrls']),
      createdAt: json['createdAt'].toDate(),
      profilePic: json['profilePic'],
      statusId: json['statusId'],
      inContactUser: List<String>.from(json['inContactUser']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'mobileNumber': mobileNumber,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'profilePic': profilePic,
      'statusId': statusId,
      'inContactUser': inContactUser,
    };
  }
}

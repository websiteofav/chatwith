// Path: lib\features\auth\models\user_model.dart

class UserModel {
  final String name;
  final String emailId;
  final String profilePic;
  final String uid;
  final String bio;
  final bool isOnline;
  final String mobileNumber;
  final List groupId;

  UserModel({
    required this.name,
    required this.emailId,
    required this.isOnline,
    required this.profilePic,
    required this.uid,
    required this.bio,
    required this.mobileNumber,
    required this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': emailId,
      'isOnline': isOnline,
      'profilePic': profilePic,
      'uid': uid,
      'bio': bio,
      'groupId': groupId,
      'mobileNumber': mobileNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      emailId: json['email'],
      isOnline: json['isOnline'] ?? false,
      profilePic: json['profilePic'],
      uid: json['uid'],
      bio: json['bio'],
      groupId: json['groupId'] ?? [],
      mobileNumber: json['mobileNumber'],
    );
  }
}

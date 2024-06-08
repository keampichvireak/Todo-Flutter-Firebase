class UserModal {
  String uid;
  String email;

  UserModal({
    required this.uid,
    required this.email,
  });

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      uid: json['uid'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}

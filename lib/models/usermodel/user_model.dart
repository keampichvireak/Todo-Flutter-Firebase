// class UserModel {
//   String email;
//   String password;

//   UserModel({
//     required this.email,
//     required this.password,
//   });

//   UserModel.fromJson(Map<String, dynamic> json)
//       : this(
//             email: json['email']! as String,
//             password: json['password']! as String);

//   UserModel copyWith({
//     String? email,
//     String? password,
//   }) {
//     return UserModel(
//       email: email ?? this.email,
//       password: password ?? this.password,
//     );
//   }

//   Map<String, Object?> toJson() {
//     return {
//       'email': email,
//       'password': password,
//     };
//   }
// }

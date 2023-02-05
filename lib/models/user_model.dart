class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? uId;
  String? code;
  String? userType;

  UserModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.code,
      this.uId,
      this.userType});

  UserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    code = json['code'];
    uId = json['uId'];
    userType = json['userType'];
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'code': code,
      'uId': uId,
      'userType': userType,
    };
  }
}

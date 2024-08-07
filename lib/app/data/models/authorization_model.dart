// To parse this JSON data, do
//
//     final authorizationModel = authorizationModelFromJson(jsonString);

import 'dart:convert';

AuthorizationModel authorizationModelFromJson(String str) => AuthorizationModel.fromJson(json.decode(str));

String authorizationModelToJson(AuthorizationModel data) => json.encode(data.toJson());

class AuthorizationModel {
  User? user;
  String? token;

  AuthorizationModel({
    this.user,
    this.token,
  });

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) => AuthorizationModel(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? userType;
  int? approved;
  String? emailVerifiedAt;
  Profile? profile;
  List<dynamic>? adresses;

  User({
    this.id,
    this.name,
    this.email,
    this.userType,
    this.approved,
    this.emailVerifiedAt,
    this.profile,
    this.adresses,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    userType: json["user_type"],
    approved: json["approved"],
    emailVerifiedAt: json["email_verified_at"],
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    adresses: json["adresses"] == null ? [] : List<dynamic>.from(json["adresses"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "user_type": userType,
    "approved": approved,
    "email_verified_at": emailVerifiedAt,
    "profile": profile?.toJson(),
    "adresses": adresses == null ? [] : List<dynamic>.from(adresses!.map((x) => x)),
  };
}

class Profile {
  int? id;
  dynamic profileImage;
  int? userId;
  String? mobileNumber;
  dynamic gender;
  dynamic birthday;
  dynamic defaultAddressId;
  String? createdAt;
  String? updatedAt;

  Profile({
    this.id,
    this.profileImage,
    this.userId,
    this.mobileNumber,
    this.gender,
    this.birthday,
    this.defaultAddressId,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    profileImage: json["profile_image"],
    userId: json["user_id"],
    mobileNumber: json["mobile_number"],
    gender: json["gender"],
    birthday: json["birthday"],
    defaultAddressId: json["default_address_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_image": profileImage,
    "user_id": userId,
    "mobile_number": mobileNumber,
    "gender": gender,
    "birthday": birthday,
    "default_address_id": defaultAddressId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? city;
  String? phoneNumber;
  String? profilePicture;
  String? id;

  UserModel(this.firstName, this.lastName, this.email, this.address,
      this.city, this.phoneNumber, this.profilePicture, this.id);
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

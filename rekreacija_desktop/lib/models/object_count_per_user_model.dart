import 'package:json_annotation/json_annotation.dart';

part 'object_count_per_user_model.g.dart';

@JsonSerializable()
class ObjectCountPerUserModel {
  String? userId;
  String? fullName;
  int? objectCount;

  ObjectCountPerUserModel(
    this.userId,
    this.fullName,
    this.objectCount,
  );

  factory ObjectCountPerUserModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectCountPerUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectCountPerUserModelToJson(this);
}
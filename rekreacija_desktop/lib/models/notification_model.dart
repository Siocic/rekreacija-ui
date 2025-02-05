import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel{
  int? id;
  String? name;
  String? description;
  DateTime? created_date;
  String? user_id;

  NotificationModel(this.id,this.name,this.description,this.created_date,this.user_id);

    factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

}
import 'package:json_annotation/json_annotation.dart';

part 'notification_insert.g.dart';

@JsonSerializable()
class NotificationInsert {
  String? name;
  String? description;
  DateTime? created_date;
  String? user_id;

  NotificationInsert(
      this.name, this.description, this.created_date, this.user_id);

  factory NotificationInsert.fromJson(Map<String, dynamic> json) =>
      _$NotificationInsertFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationInsertToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'object_update.g.dart';

@JsonSerializable()
class ObjectUpdate {
  String? name;
  DateTime? updated_date;
  String? address;
  String? city;
  String? description;
  double? price;
  String? user_id;
  String? ObjectImage;
  List<int>? sportId;

  ObjectUpdate(
      this.name,
      this.updated_date,
      this.address,
      this.city,
      this.description,
      this.price,
      this.user_id,
      this.ObjectImage,
      this.sportId);

  factory ObjectUpdate.fromJson(Map<String, dynamic> json) =>
      _$ObjectUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectUpdateToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'object_insert.g.dart';

@JsonSerializable()
class ObjectInsert {
  String? name;
  DateTime? created_date;
  String? address;
  String? city;
  String? description;
  double? price;
  String? user_id;
  String? ObjectImage;
  List<int>? sportId;

  ObjectInsert(this.name, this.created_date, this.address, this.city,
      this.description, this.price, this.user_id,this.ObjectImage,this.sportId);

      
  factory ObjectInsert.fromJson(Map<String, dynamic> json) =>
      _$ObjectInsertFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectInsertToJson(this);
}

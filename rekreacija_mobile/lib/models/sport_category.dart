
import 'package:json_annotation/json_annotation.dart';

part 'sport_category.g.dart';

@JsonSerializable()
class SportCategory{
  int? id;
  String? name;

  SportCategory({this.id,this.name});

  factory SportCategory.fromJson(Map<String, dynamic> json) => _$SportCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SportCategoryToJson(this);
}
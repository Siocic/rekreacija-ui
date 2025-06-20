import 'package:json_annotation/json_annotation.dart';

part 'object_model.g.dart';

@JsonSerializable()
class ObjectModel {
  int? id;
  String? name;
  DateTime? created_date;
  DateTime? updated_date;
  String? address;
  String? city;
  String? description;
  double? price;
  String? user_id;
  List<int>? sportsId;
  String? objectImage;
  String? imagePath;
  double? rating;
  bool? isFavorites;

  ObjectModel(this.id, this.name, this.created_date, this.updated_date, this.address, this.city, this.description, this.price, this.user_id,this.sportsId,this.objectImage,this.imagePath, this.rating,this.isFavorites);


  factory ObjectModel.fromJson(Map<String, dynamic> json) => _$ObjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectModelToJson(this);
}
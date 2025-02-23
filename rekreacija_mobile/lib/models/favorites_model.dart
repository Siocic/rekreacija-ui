import 'package:json_annotation/json_annotation.dart';

part 'favorites_model.g.dart';

@JsonSerializable()
class FavoritesModel {
  int? object_id;
  String? user_id;

  FavoritesModel(this.object_id,this.user_id);

   factory FavoritesModel.fromJson(Map<String, dynamic> json) => _$FavoritesModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesModelToJson(this);
}

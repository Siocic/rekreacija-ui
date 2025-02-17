import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  int? id;
  String? comment;
  double? rating;
  DateTime? created_date;
  String? user_id;
  int? object_id;

  ReviewModel(this.id, this.comment, this.rating, this.created_date,
      this.user_id, this.object_id);

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
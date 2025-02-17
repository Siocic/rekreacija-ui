import 'package:json_annotation/json_annotation.dart';

part 'review_insert_model.g.dart';

@JsonSerializable()
class ReviewInsertModel {
  String? comment;
  double? rating;
  DateTime? created_date;
  String? user_id;
  int? object_id;

  ReviewInsertModel(this.comment, this.rating, this.created_date, this.user_id,
      this.object_id);

  factory ReviewInsertModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewInsertModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewInsertModelToJson(this);
}

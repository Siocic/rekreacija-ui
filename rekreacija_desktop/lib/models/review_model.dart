import 'package:json_annotation/json_annotation.dart';
import 'package:rekreacija_desktop/models/user_model.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  int? id;
  String? comment;
  double? rating;
  DateTime? created_date;
  String? user_id;
  int? object_id;
  final UserModel? user;

  ReviewModel(this.id, this.comment, this.rating, this.created_date,
      this.user_id, this.object_id, this.user);

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

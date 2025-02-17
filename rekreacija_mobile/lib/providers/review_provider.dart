import 'package:rekreacija_mobile/models/review_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';

class ReviewProvider extends BaseProvider<ReviewModel> {
  ReviewProvider() : super("Review");

  @override
  ReviewModel fromJson(data) {
    return ReviewModel.fromJson(data);
  }
}
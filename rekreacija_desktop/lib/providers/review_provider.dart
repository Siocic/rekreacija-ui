import 'dart:convert';
import 'package:rekreacija_desktop/models/review_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:http/http.dart' as http;

class ReviewProvider extends BaseProvder<ReviewModel> {
  static String? _baseUrl;

  ReviewProvider() : super("Review") {
    _baseUrl = const String.fromEnvironment("BASE_URL",
        defaultValue: "http://localhost:5246/");
  }

  @override
  ReviewModel fromJson(data) {
    return ReviewModel.fromJson(data);
  }

  Future<List<ReviewModel>> getReviewsForMyObjects() async {
    var url = "${_baseUrl}Review/getReviewsForMyObjects";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<ReviewModel> result = (data as List<dynamic>)
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }
}

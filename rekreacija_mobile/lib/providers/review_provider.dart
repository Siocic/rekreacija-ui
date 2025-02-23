import 'package:rekreacija_mobile/models/review_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewProvider extends BaseProvider<ReviewModel> {
  static String? _baseUrl;

  ReviewProvider() : super("Review") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  @override
  ReviewModel fromJson(data) {
    return ReviewModel.fromJson(data);
  }

  Future<List<ReviewModel>> getReviewofObject(int object_id) async {
    var url = "${_baseUrl}Review/getReviewForObject/${object_id}";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        List<ReviewModel> result = (data as List<dynamic>)
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return result;
      } else {
        throw new Exception("Unknow exception");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

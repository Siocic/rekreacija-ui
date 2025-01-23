import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rekreacija_mobile/models/sport_category.dart';
import 'package:rekreacija_mobile/utils/utils.dart';

class SportCategoryProvider {
  static String? _baseUrl;
  SportCategoryProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  Future<List<SportCategory>> get() async {
    var url = "${_baseUrl}SportCategory/GetAll";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = data
          .map((e) => SportCategory.fromJson(e))
          .toList()
          .cast<SportCategory>();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }
  
  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception("Something bad happended, please try again");
    }
  }
}

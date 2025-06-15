import 'dart:convert';
import 'package:rekreacija_desktop/models/object_count_per_user_model.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:http/http.dart' as http;

class ObjectProvider extends BaseProvder<ObjectModel> {
  static String? _baseUrl;

  ObjectProvider() : super("Object") {
    _baseUrl = const String.fromEnvironment("BASE_URL",
        defaultValue: "http://localhost:5246/");
  }

  @override
  ObjectModel fromJson(data) {
    return ObjectModel.fromJson(data);
  }

  Future<List<ObjectModel>> getObjectOfLoggedUser() async {
    var url = "${_baseUrl}Object/getObjectsOfUser";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
     List<ObjectModel> result = (data as List<dynamic>)
        .map((json) => ObjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }
  
  Future<List<ObjectCountPerUserModel>> getCountObjectPerUser() async {
    var url = "${_baseUrl}Object/getCountedObjectPerUser";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
     List<ObjectCountPerUserModel> result = (data as List<dynamic>)
        .map((json) => ObjectCountPerUserModel.fromJson(json as Map<String, dynamic>))
        .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }
}

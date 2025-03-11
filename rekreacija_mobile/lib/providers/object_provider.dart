import 'dart:convert';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:http/http.dart' as http;


class ObjectProvider extends BaseProvider<ObjectModel> {
  static String? _baseUrl;
  ObjectProvider() : super("Object") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  @override
  ObjectModel fromJson(data) {
    return ObjectModel.fromJson(data);
  }

  Future<List<ObjectModel>> getFavoritesObjectOfUser() async {
     var url = "${_baseUrl}Object/getFavoritesObjectOfUser";
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

  Future<List<ObjectModel>> getObjects(int categoryId,{String? name}) async {
     var url = "${_baseUrl}Object/getObjects/$categoryId";
      if(name!=null && name.isNotEmpty){
        url+="?name=${Uri.encodeComponent(name)}";
      }
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

  Future<List<ObjectModel>>getRecommended()async{
    var url="${_baseUrl}Object/getRecommended";
    var uri=Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if(isValidResponse(response))
    {
      var data=jsonDecode(response.body);
       List<ObjectModel> result = (data as List<dynamic>)
        .map((json) => ObjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
      return result;
    }
    else{
      throw new Exception("Unknow exception");
    }
  }

}

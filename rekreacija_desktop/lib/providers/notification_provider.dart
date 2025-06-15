import 'dart:convert';
import 'package:rekreacija_desktop/models/notification_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends BaseProvder<NotificationModel>{
 static String? _baseUrl;
 
  NotificationProvider():super("Notification"){
      _baseUrl = const String.fromEnvironment("BASE_URL",
        defaultValue: "http://localhost:5246/");
  }
   @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }

  Future<List<NotificationModel>> getNotificationsOfUser() async {
    var url = "${_baseUrl}Notification/getNotificationsOfUser";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
     List<NotificationModel> result = (data as List<dynamic>)
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }
}
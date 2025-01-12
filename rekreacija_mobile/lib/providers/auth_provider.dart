import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rekreacija_mobile/models/registration_model.dart';

class AuthProvider {
  static String? _baseUrl;
  AuthProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  Future<void> userRegister(RegistrationModel model, num flag) async {
    final url = "${_baseUrl}Auth/Register?flag=$flag";
    final uri = Uri.parse(url);
   
    try {
      final jsonRequest = jsonEncode(model.toJson());
      final response = await http.post(
        uri,
        body: jsonRequest,
        headers: {
          "Content-Type": "application/json",
        },
      );
      _isValidResponse(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  bool _isValidResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final errorBody = jsonDecode(response.body);
      final message =
          errorBody['message'] ?? "Something went wrong. Please try again.";
      throw message;
    } else if (response.statusCode >= 500) {
      var messageErr =
          "Something went wrong on our side. Please try again later.";
      throw messageErr;
    } else {
      var expMessage = "Unexpected error. Please try again.";
      throw expMessage;
    }
  }  
}

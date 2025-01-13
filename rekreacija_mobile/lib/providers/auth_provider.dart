import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rekreacija_mobile/models/login_model.dart';
import 'package:rekreacija_mobile/models/registration_model.dart';

class AuthProvider {
  static String? _baseUrl;
  final _secureStorage = const FlutterSecureStorage();
  AuthProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  Future<void> userLogin(LoginModel model) async {
    final url = "${_baseUrl}Auth/Login";
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
      if (_isValidResponse(response)) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        final payload = JwtDecoder.decode(token);

        if (payload['Role'] != 'FizickoLice') {
          var message = "Something went wrong";
          throw message;
        }
        await _secureStorage.write(key: 'jwt_token', value: token);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
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

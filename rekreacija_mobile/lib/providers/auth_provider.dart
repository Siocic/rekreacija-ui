import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rekreacija_mobile/models/change_password_model.dart';
import 'package:rekreacija_mobile/models/login_model.dart';
import 'package:rekreacija_mobile/models/registration_model.dart';
import 'package:rekreacija_mobile/models/user_model.dart';
import 'package:rekreacija_mobile/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
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
      if (isValidResponse(response)) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        final payload = JwtDecoder.decode(token);
        String userRole = payload.entries
            .firstWhere((e) => e.key.toLowerCase().contains('role'),
                orElse: () => MapEntry('role', ''))
            .value;

        if (userRole != 'FizickoLice') {
          var message = "Invalid email or password";
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
      isValidResponse(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> getUserProfile() async {
    var url = "${_baseUrl}Auth/getUser";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = UserModel.fromJson(data);
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

  Future<void> editProfile(UserModel model) async {
    var url = "${_baseUrl}Auth/editUser";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      final jsonRequest = jsonEncode(model.toJson());
      final response =
          await http.post(uri, body: jsonRequest, headers: headers);
      isValidResponse(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> changePassword(ChangePasswordModel model) async {
    var url = "${_baseUrl}Auth/change";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      final jsonRequest = jsonEncode(model.toJson());
      final response =
          await http.post(uri, body: jsonRequest, headers: headers);
      isValidResponse(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
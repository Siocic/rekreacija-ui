import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rekreacija_desktop/models/change_password_model.dart';
import 'package:rekreacija_desktop/models/login_model.dart';
import 'package:rekreacija_desktop/models/user_model.dart';
import 'package:rekreacija_desktop/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  static String? _baseUrl;
  final _secureStorage = const FlutterSecureStorage();
  AuthProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5246/");
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
        String userRole = payload.entries.firstWhere((e)
        =>e.key.toLowerCase().contains('role'),orElse: ()=>MapEntry('role', '')).value;

        if (userRole == 'FizickoLice') {
          var message = "Invalid email or password";
          throw message;
        } else if (userRole == 'PravnoLice' &&
            payload['IsApproved'] == false) {
          var message = "You are not allowed yet to login";
          throw message;
        }
        await _secureStorage.write(key: 'jwt_token', value: token);
      }
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

  Future<List<UserModel>>getAllUser()async{
     var url = "${_baseUrl}Auth/GetAllUsers";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<UserModel> result = (data as List<dynamic>)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
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

  Future<List<UserModel>> getUserOfRolePravnoLice() async {
    var url = "${_baseUrl}Auth/getUserOfPravnoLice";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<UserModel> result = (data as List<dynamic>)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

  Future<List<UserModel>> getUserOfFizickoLice() async {
    var url = "${_baseUrl}Auth/getUserOfFizickoLice";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<UserModel> result = (data as List<dynamic>)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

  Future<List<UserModel>> getUserThatNotApprovedYet() async {
    var url = "${_baseUrl}Auth/getNotApprovedUser";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<UserModel> result = (data as List<dynamic>)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

  Future<bool> approveRegistartion(String userId) async {
    var url = "${_baseUrl}Auth/approve-registartion?userId=$userId";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      final response = await http.post(uri, headers: headers);
      if (isValidResponse(response)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

Future<String> getUserRole() async {
  const secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'jwt_token');

  if (token == null || JwtDecoder.isExpired(token)) {
    return '';
  }

  try {
    final payload = JwtDecoder.decode(token);
      String userRole = payload.entries.firstWhere((e)
        =>e.key.toLowerCase().contains('role'),orElse: ()=>MapEntry('role', '')).value;

    final role = userRole;
    return role;
  } catch (e) {
    return '';
  }
}

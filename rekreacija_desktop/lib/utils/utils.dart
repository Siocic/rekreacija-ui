import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('##,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

Future<Map<String, String>> getAuthHeaders() async {
  const secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'jwt_token');

  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
}

Future<String> getUserFullName() async {
  const secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'jwt_token');

  if (token == null || JwtDecoder.isExpired(token)) {
    return ' ';
  }

  try {
    final payload = JwtDecoder.decode(token);
    final firstName = payload['FirstName'] ?? ' ';
    final lastName = payload['LastName'] ?? '';
    return '$firstName $lastName';
  } catch (e) {
    return ' ';
  }
}

Future<String> getUserId() async {
  const secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'jwt_token');

  if (token == null || JwtDecoder.isExpired(token)) {
    return ' ';
  }

  try {
    final payload = JwtDecoder.decode(token);
    final userId = payload['sub'] ?? ' ';  
    return '$userId';
  } catch (e) {
    return ' ';
  }
}

bool isValidResponse(http.Response response) {
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

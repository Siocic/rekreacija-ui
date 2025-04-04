import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

String formatNumber(double number) {
  var f = NumberFormat("#,##0.0");
  return f.format(number);
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

bool isValidResponse(Response response) {
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

Future<bool> isTokenExpired() async {
  const secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'jwt_token');

  if (token == null) return true;

  try {
    final parts = token.split(".");
    if (parts.length != 3) return true;

    final payload = json
        .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    final int exp = payload["exp"] ?? 0;

    final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return currentTime >= exp;
  } catch (e) {
    return true;
  }
}

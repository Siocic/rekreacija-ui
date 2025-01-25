import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
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

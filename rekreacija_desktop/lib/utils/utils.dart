import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('##,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input)
{
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

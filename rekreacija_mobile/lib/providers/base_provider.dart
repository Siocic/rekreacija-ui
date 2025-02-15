import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:http/http.dart' as http;

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  Future<List<T>> Get() async {
    var url = "$_baseUrl$_endpoint/GetAll";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      var response = await http.get(uri, headers: headers);
      isValidResponse(response);
      var data = jsonDecode(response.body);
      if (data is List) {
        return data
            .map<T>((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

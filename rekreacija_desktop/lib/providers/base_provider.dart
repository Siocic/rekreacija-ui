import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/utils/utils.dart';

abstract class BaseProvder<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  BaseProvder(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5246/");
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

  Future<T> Insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint/Insert";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      var jsonRequest = jsonEncode(request);
      var response = await http.post(uri, headers: headers, body: jsonRequest);
      isValidResponse(response);
      var data = jsonDecode(response.body);
      return fromJson(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> Delete(int id) async {
    var url = "$_baseUrl$_endpoint/Delete/$id";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    try {
      var response = await http.delete(uri, headers: headers);
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
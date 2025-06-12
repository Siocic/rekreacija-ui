import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rekreacija_desktop/models/holiday_model.dart';
import 'package:rekreacija_desktop/models/object_holiday_model.dart';
import 'package:rekreacija_desktop/utils/utils.dart';

class HolidayProvider {
  static String _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5246/");

  Future<List<HolidayModel>> getAllHolidays() async {
    final url = Uri.parse("${_baseUrl}Holiday/GetAllHolidays");
    final headers = await getAuthHeaders();
    final response = await http.get(url, headers: headers);
    if (isValidResponse(response)) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => HolidayModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load holidays");
    }
  }

  Future<List<HolidayModel>> getObjectHolidays(int objectId) async {
    final url = Uri.parse("${_baseUrl}Holiday/GetObjectHolidays/$objectId");
    final headers = await getAuthHeaders();
    final response = await http.get(url, headers: headers);
    if (isValidResponse(response)) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => HolidayModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load object holidays");
    }
  }

  Future<void> addHoliday(HolidayModel holiday) async {
    final url = Uri.parse("${_baseUrl}Holiday/AddHoliday");
    final headers = await getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(holiday.toJson()),
    );
    if (!isValidResponse(response)) {
      throw Exception("Failed to create holiday");
    }
  }

  Future<void> assignObjectHoliday(ObjectHolidayModel model) async {
    final url = Uri.parse("${_baseUrl}Holiday/AddObjectHoliday");
    final headers = await getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(model.toJson()),
    );
    if (!isValidResponse(response)) {
      throw Exception("Failed to assign holiday to object");
    }
  }
}

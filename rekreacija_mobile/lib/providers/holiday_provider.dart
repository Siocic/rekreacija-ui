import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rekreacija_mobile/models/holiday_model.dart';
import 'package:rekreacija_mobile/utils/utils.dart';

class HolidayProvider {
  static String _baseUrl = const String.fromEnvironment(
    "baseUrl",
    defaultValue: "http://10.0.2.2:5246/",
  );

  Future<List<HolidayModel>> getHolidaysForObject(int objectId) async {
    final url = Uri.parse("${_baseUrl}Holiday/GetByObject/$objectId");
    final headers = await getAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.body.trim().isEmpty) return [];

    if (!isValidResponse(response)) {
      throw Exception("Failed to load holidays: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);
    return (data as List).map((e) => HolidayModel.fromJson(e)).toList();
  }
}

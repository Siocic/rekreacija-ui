import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rekreacija_desktop/models/holiday_model.dart';
import 'package:rekreacija_desktop/models/object_holiday_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';

class HolidayProvider extends BaseProvder<HolidayModel> {
  static String? _baseUrl;
  HolidayProvider() : super("Holiday") {
    _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5246/");
  }

  @override
  HolidayModel fromJson(data) => HolidayModel.fromJson(data);

  Future<HolidayModel> addHoliday(HolidayModel holiday) async {
    var uri = Uri.parse("${_baseUrl}Holiday");
    var headers = await getAuthHeaders();
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(holiday.toJson()),
    );

    if (isValidResponse(response)) {
      return HolidayModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add holiday");
    }
  }

  Future<void> addObjectHoliday(ObjectHolidayModel objectHoliday) async {
    var uri = Uri.parse("${_baseUrl}ObjectHoliday");
    var headers = await getAuthHeaders();
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(objectHoliday.toJson()),
    );

    if (!isValidResponse(response)) {
      throw Exception("Failed to add object holiday");
    }
  }
}

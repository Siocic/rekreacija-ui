import 'dart:convert';
import 'package:rekreacija_mobile/models/appointment_model.dart';
import 'package:rekreacija_mobile/models/my_reservation_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:http/http.dart' as http;

class AppointmentProvider extends BaseProvider<AppointmentModel> {
  static String? _baseUrl;

  AppointmentProvider() : super("Appointment") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5246/");
  }

  @override
  AppointmentModel fromJson(data) {
    return AppointmentModel.fromJson(data);
  }

  Future<List<MyReservationModel>> getMyReservation() async {
    var url = "${_baseUrl}Appointment/GetMyReservation";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<MyReservationModel> result = (data as List<dynamic>)
          .map((json) =>
              MyReservationModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

  Future<bool> getReservedTimes(
      int objectId, DateTime startTime, DateTime endTime) async {
    var url = "${_baseUrl}Appointment/GetReservedTimes";
    var uri = Uri.parse(url).replace(
      queryParameters: {
          "objectId": objectId.toString(),
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
      }
    );
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data as bool;
    } else {
      throw Exception('Failed to check reserved time');
    }
  }
}

import 'dart:convert';
import 'package:rekreacija_desktop/models/appointment_model.dart';
import 'package:rekreacija_desktop/models/my_clients_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:http/http.dart' as http;

class AppointmentProvider extends BaseProvder<AppointmentModel> {
  static String? _baseUrl;
  AppointmentProvider() : super("Appointment") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5246/");
  }

  @override
  AppointmentModel fromJson(data) {
    return AppointmentModel.fromJson(data);
  }

  Future<List<AppointmentModel>> getAppointments() async {
    var url = "${_baseUrl}Appointment/GetAppointments";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<AppointmentModel> result = (data as List<dynamic>)
          .map(
              (json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

  Future<bool>approveAppointment(int id)async{
    var url = "${_baseUrl}Appointment/ApproveAppointment?id=${id}";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.post(uri,headers: headers);

    if(isValidResponse(response)){
      var data = jsonDecode(response.body);
      return data;
    }
    else{
      throw new Exception("Unknow exception");
    }
  }

  Future<List<MyClientsModel>>getMyClients()async{
        var url = "${_baseUrl}Appointment/GetMyClients";
    var uri = Uri.parse(url);
    var headers = await getAuthHeaders();
    var response = await http.get(uri, headers: headers);
     if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<MyClientsModel> result = (data as List<dynamic>)
          .map(
              (json) => MyClientsModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw new Exception("Unknow exception");
    }
  }

}




import 'package:rekreacija_mobile/models/appointment_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';

class AppointmentProvider extends BaseProvider<AppointmentModel> {
  AppointmentProvider() : super("Appointment");

  @override
  AppointmentModel fromJson(data) {
    return AppointmentModel.fromJson(data);
  }
}

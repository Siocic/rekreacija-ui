import 'package:rekreacija_mobile/models/notification_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super("Notification");

  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }
}

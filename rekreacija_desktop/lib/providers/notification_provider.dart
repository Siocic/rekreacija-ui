import 'package:rekreacija_desktop/models/notification_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';

class NotificationProvider extends BaseProvder<NotificationModel>{
  NotificationProvider():super("Notification"){}

   @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }
}
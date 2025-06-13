class AppointmentInsertModel {
  DateTime appointment_date;
  DateTime start_time;
  DateTime end_time;
  bool is_approved;
  int object_id;
  String user_id;
  double amount;

  AppointmentInsertModel({
    required this.appointment_date,
    required this.start_time,
    required this.end_time,
    required this.is_approved,
    required this.object_id,
    required this.user_id,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'appointment_date': appointment_date.toIso8601String(),
        'start_time': start_time.toIso8601String(),
        'end_time': end_time.toIso8601String(),
        'is_approved': is_approved,
        'object_id': object_id,
        'user_id': user_id,
        'amount': amount,
      };
}

class AttendanceModel {
  final int? id;
  final int userId;
  final int eventId;
  final String checkInTime;
  final String qrCodeValue;

  AttendanceModel({
    this.id,
    required this.userId,
    required this.eventId,
    required this.checkInTime,
    required this.qrCodeValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'check_in_time': checkInTime,
      'qr_code_value': qrCodeValue,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      userId: map['user_id'],
      eventId: map['event_id'],
      checkInTime: map['check_in_time'],
      qrCodeValue: map['qr_code_value'],
    );
  }
}

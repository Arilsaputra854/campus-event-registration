class EventRegistrationModel {
  final int? id;
  final int userId;
  final int eventId;
  final String registrationTime;

  EventRegistrationModel({
    this.id,
    required this.userId,
    required this.eventId,
    required this.registrationTime,
  });

  factory EventRegistrationModel.fromMap(Map<String, dynamic> map) {
    return EventRegistrationModel(
      id: map['id'],
      userId: map['user_id'],
      eventId: map['event_id'],
      registrationTime: map['registration_time'] ?? '', // <-- ✅ prevent null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'registration_time': registrationTime,
    };
  }
}

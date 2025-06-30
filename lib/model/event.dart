class EventModel {
  final int? id;
  final String title;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String posterUrl;
  final String createdAt;
  final String updatedAt;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.posterUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      posterUrl: map['poster_url'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'start_time': startTime,
      'end_time': endTime,
      'poster_url': posterUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

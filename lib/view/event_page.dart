import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:campus_event_registration/model/event.dart';
import 'package:campus_event_registration/view/event_detail_page.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<EventModel> _myEvents = [];
  bool _isLoading = true;

  final int _loggedInUserId = 1;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final registrations = await EventRegistrationDatabase.getUserEvents(
      _loggedInUserId,
    );

    final List<EventModel> events = [];
    for (var reg in registrations) {
      final allEvents = await EventDatabase.getAllEvents();
      final event = allEvents.firstWhere(
        (e) => e.id == reg.eventId,
        orElse:
            () => EventModel(
              id: 0,
              title: "Tidak ditemukan",
              description: "-",
              location: "-",
              startTime: "-",
              endTime: "-",
              posterUrl: "",
              createdAt: "",
              updatedAt: "",
            ),
      );
      events.add(event);
    }

    setState(() {
      _myEvents = events;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Saya')),
      body: _isLoading
    ? const Center(child: CircularProgressIndicator())
    : _myEvents.isEmpty
        ? const Center(child: Text('Belum ada event yang kamu ikuti.'))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _myEvents.length,
            itemBuilder: (context, index) {
              final event = _myEvents[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.event_note, color: Colors.deepPurple),
                  title: Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        event.location,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mulai: ${event.startTime}',
                        style: const TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailEventPage(event: event),
                      ),
                    );
                  },
                ),
              );
            },
          ),

    );
  }
}

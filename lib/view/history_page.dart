import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:campus_event_registration/model/attendance.dart';
import 'package:campus_event_registration/model/event.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _attendanceHistory = [];
  bool _isLoading = true;
  int? _loggedInUserId;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _loggedInUserId = userId;

    final attendances = await AttendanceDatabase.getUserAttendances(userId);
    final events = await EventDatabase.getAllEvents();

    final List<Map<String, dynamic>> combined =
        attendances.map((att) {
          final event = events.firstWhere(
            (e) => e.id == att.eventId,
            orElse:
                () => EventModel(
                  id: 0,
                  title: 'Event tidak ditemukan',
                  description: '-',
                  location: '-',
                  startTime: '-',
                  endTime: '-',
                  posterUrl: '',
                  createdAt: '',
                  updatedAt: '',
                ),
          );

          return {'event': event, 'attendance': att};
        }).toList();

    setState(() {
      _attendanceHistory = combined;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Absen')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _attendanceHistory.isEmpty
              ? const Center(child: Text('Belum ada riwayat absen.'))
              : ListView.builder(
                itemCount: _attendanceHistory.length,
                itemBuilder: (context, index) {
                  final data = _attendanceHistory[index];
                  final EventModel event = data['event'];
                  final AttendanceModel attendance = data['attendance'];

                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text('Check-in: ${attendance.checkInTime}'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  );
                },
              ),
    );
  }
}

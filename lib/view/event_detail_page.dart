import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:campus_event_registration/model/event.dart';
import 'package:campus_event_registration/view/add_event_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DetailEventPage extends StatefulWidget {
  final EventModel event;
  const DetailEventPage({super.key, required this.event});

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {
  bool isAdmin = false;
  late EventModel _event;

  @override
  void initState() {
    super.initState();

    _event = widget.event;
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool('is_admin') ?? false;
    });
  }

  String _formatDateTime(String value) {
    final dt = DateTime.tryParse(value);
    if (dt == null) return value;
    return DateFormat('EEE, dd MMM yyyy • HH:mm').format(dt);
  }

  Future<void> _deleteEvent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Event'),
            content: const Text('Apakah kamu yakin ingin menghapus event ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirm ?? false) {
      final db = await EventDatabase.getDatabase();
      await db.delete('events', where: 'id = ?', whereArgs: [_event.id]);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Event berhasil dihapus')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.place, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_event.location),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatDateTime(_event.startTime)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_off, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatDateTime(_event.endTime)),
              ],
            ),
            const Divider(height: 32),
            Text(_event.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (isAdmin) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEventPage(event: _event),
                        ),
                      );

                      if (result == true && _event.id != null) {
                        final updatedEvent = await EventDatabase.getEventById(
                          _event.id!,
                        );
                        if (updatedEvent != null) {
                          setState(() {
                            _event = updatedEvent;
                          });
                        }
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _deleteEvent,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'QR Code untuk Absen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: QrImageView(
                    data: 'absen_event_${_event.id}', // ← Data QR unik
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

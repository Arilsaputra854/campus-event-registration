import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:campus_event_registration/model/event.dart';
import 'package:campus_event_registration/model/user.dart';
import 'package:campus_event_registration/view/add_event_page.dart';
import 'package:campus_event_registration/view/event_detail_page.dart';
import 'package:campus_event_registration/view/event_page.dart';
import 'package:campus_event_registration/view/history_page.dart';
import 'package:campus_event_registration/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> _events = [];
  String _userName = 'Pengguna';
  bool isAdmin = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await EventDatabase.getAllEvents();
    setState(() {
      _events = events;
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    final isAdminFlag = prefs.getBool('is_admin') ?? false;

    if (userId != null) {
      final db = await UserDatabase.getDatabase();
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (result.isNotEmpty) {
        final user = UserModel.fromMap(result.first);
        setState(() {
          _userName = user.name;
          isAdmin = isAdminFlag;
        });
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.tryParse(dateTimeStr);
    if (dateTime == null) return '-';
    return DateFormat('EEE, dd MMM yyyy • HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_userName),
              accountEmail: Text(isAdmin ? 'Admin' : ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.deepPurple),
              ),
              decoration: const BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Event Saya'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History Absen'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _events.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Belum ada event tersedia.',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.event, color: Colors.white),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.place, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: const TextStyle(color: Colors.black87),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateTime(event.startTime),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEventPage()),
                );
                _loadEvents(); // refresh setelah tambah event
              },
              child: const Icon(Icons.add),
              tooltip: 'Tambah Event',
            )
          : null,
    );
  }
}

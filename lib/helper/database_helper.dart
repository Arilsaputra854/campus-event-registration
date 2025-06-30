import 'package:campus_event_registration/model/attendance.dart';
import 'package:campus_event_registration/model/event.dart';
import 'package:campus_event_registration/model/event_registration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user.dart';

class UserDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'user_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT UNIQUE,
      nim TEXT,
      phone TEXT,
      password TEXT,
      is_admin INTEGER DEFAULT 0
    )
  ''');

        await db.insert('users', {
          'name': 'Admin',
          'email': 'admin',
          'nim': 'admin',
          'phone': 'admin',
          'password': 'admin',
          'is_admin': 1,
        });
      },
    );
    return _database!;
  }

  static Future<int> insertUser(UserModel user) async {
    final db = await getDatabase();
    return await db.insert('users', user.toMap());
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await getDatabase();
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }
}

class EventDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'event_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            location TEXT,
            start_time TEXT,
            end_time TEXT,
            poster_url TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');

        final now = DateTime.now();
        final events = [
          {
            'title': 'Seminar AI dan Masa Depan',
            'description': 'Diskusi tentang peran AI dalam kehidupan.',
            'location': 'Aula Kampus A',
            'start_time': now.toIso8601String(),
            'end_time': now.add(const Duration(hours: 2)).toIso8601String(),
            'poster_url': '',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
          {
            'title': 'Pelatihan Flutter Dasar',
            'description': 'Belajar membuat aplikasi mobile dengan Flutter.',
            'location': 'Lab Komputer 1',
            'start_time': now.toIso8601String(),
            'end_time': now.add(const Duration(hours: 3)).toIso8601String(),
            'poster_url': '',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
          {
            'title': 'Workshop UI/UX Design',
            'description': 'Mendesain aplikasi yang user-friendly.',
            'location': 'Ruang Rapat Lt.2',
            'start_time': now.toIso8601String(),
            'end_time':
                now
                    .add(const Duration(hours: 1, minutes: 30))
                    .toIso8601String(),
            'poster_url': '',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
          {
            'title': 'Pengenalan Cyber Security',
            'description': 'Dasar-dasar keamanan digital.',
            'location': 'Aula Kampus B',
            'start_time': now.toIso8601String(),
            'end_time': now.add(const Duration(hours: 2)).toIso8601String(),
            'poster_url': '',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
          {
            'title': 'Lomba Coding Hackathon',
            'description': 'Bertanding membuat solusi digital dalam 1 hari.',
            'location': 'Online via Zoom',
            'start_time': now.toIso8601String(),
            'end_time': now.add(const Duration(hours: 5)).toIso8601String(),
            'poster_url': '',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
        ];

        for (var event in events) {
          await db.insert('events', event);
        }
      },
    );
    return _database!;
  }

  static Future<int> updateEvent(EventModel event) async {
    final db = await getDatabase();
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<int> insertEvent(EventModel event) async {
    final db = await getDatabase();
    return await db.insert('events', event.toMap());
  }

  static Future<EventModel?> getEventById(int id) async {
    final db = await getDatabase();
    final maps = await db.query('events', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return EventModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<EventModel>> getAllEvents() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return EventModel.fromMap(maps[i]);
    });
  }

  static Future<void> deleteAllEvents() async {
    final db = await getDatabase();
    await db.delete('events');
  }
}

class EventRegistrationDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'registration_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE event_registrations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            event_id INTEGER,
            registration_time TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<bool> isUserRegistered(int userId, int eventId) async {
    final db = await getDatabase();
    final result = await db.query(
      'event_registrations',
      where: 'user_id = ? AND event_id = ?',
      whereArgs: [userId, eventId],
    );
    return result.isNotEmpty;
  }

  static Future<void> registerUserToEvent(int userId, int eventId) async {
    final db = await getDatabase();
    await db.insert('event_registrations', {
      'user_id': userId,
      'event_id': eventId,
      'registration_time': DateTime.now().toIso8601String(), // ✅ tambahkan ini
    });
  }

  static Future<int> insert(EventRegistrationModel reg) async {
    final db = await getDatabase();
    return await db.insert('event_registrations', reg.toMap());
  }

  static Future<List<EventRegistrationModel>> getUserEvents(int userId) async {
    final db = await getDatabase();
    final maps = await db.query(
      'event_registrations',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return EventRegistrationModel.fromMap(maps[i]);
    });
  }
}

class AttendanceDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'attendance_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE attendances (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            event_id INTEGER,
            check_in_time TEXT,
            qr_code_value TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<List<AttendanceModel>> getUserAttendances(int userId) async {
    final db = await getDatabase();
    final result = await db.query(
      'attendances',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((e) => AttendanceModel.fromMap(e)).toList();
  }
}

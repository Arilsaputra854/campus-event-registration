import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:campus_event_registration/model/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final EventModel? event; // nullable

  const AddEventPage({super.key, this.event});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _posterUrlController = TextEditingController();

  DateTime? _startTime;
  DateTime? _endTime;

  bool get isEditMode => widget.event != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final e = widget.event!;
      _titleController.text = e.title;
      _descriptionController.text = e.description;
      _locationController.text = e.location;
      _posterUrlController.text = e.posterUrl;
      _startTime = DateTime.tryParse(e.startTime);
      _endTime = DateTime.tryParse(e.endTime);
    }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startTime : _endTime) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        _startTime = dateTime;
      } else {
        _endTime = dateTime;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field dan waktu')),
      );
      return;
    }

    final now = DateTime.now();
    final event = EventModel(
      id: widget.event?.id,
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      startTime: _startTime!.toIso8601String(),
      endTime: _endTime!.toIso8601String(),
      posterUrl: _posterUrlController.text,
      createdAt: widget.event?.createdAt ?? now.toIso8601String(),
      updatedAt: now.toIso8601String(),
    );

    if (isEditMode) {
      await EventDatabase.updateEvent(event);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event berhasil diperbarui')),
      );
    } else {
      await EventDatabase.insertEvent(event);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event berhasil ditambahkan')),
      );
    }

    Navigator.pop(context, true);
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Pilih waktu';
    return DateFormat('dd MMM yyyy • HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Event' : 'Tambah Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Event'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Judul wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Deskripsi wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Lokasi wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: _posterUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Poster (opsional)',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Waktu Mulai'),
                subtitle: Text(_formatDateTime(_startTime)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(isStart: true),
              ),
              ListTile(
                title: const Text('Waktu Selesai'),
                subtitle: Text(_formatDateTime(_endTime)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(isStart: false),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: Text(isEditMode ? 'Update Event' : 'Simpan Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

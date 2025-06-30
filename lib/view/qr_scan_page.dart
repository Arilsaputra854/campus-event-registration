import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import '../helper/database_helper.dart';
import '../model/attendance.dart';

class QRScanPage extends StatefulWidget {
  final int eventId;
  final int userId;

  const QRScanPage({super.key, required this.eventId, required this.userId});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _hasScanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (_hasScanned) return;
      _hasScanned = true;

      final String now = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      final attendance = AttendanceModel(
        userId: widget.userId,
        eventId: widget.eventId,
        checkInTime: now,
        qrCodeValue: scanData.code ?? '',
      );

      await AttendanceDatabase.getDatabase().then((db) {
        db.insert('attendances', attendance.toMap());
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absen berhasil disimpan')),
      );

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Arahkan ke QR untuk absen...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../theme/colors/light_colors.dart';
import 'luardinasambil.dart';

class luardinas extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  @override
  State<luardinas> createState() => _luardinas();
}

class _luardinas extends State<luardinas> {
  bool isNavigating = false; // Add this line
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Absensi Luar Kantor"),
        backgroundColor: LightColors.primary, // Use your preferred color
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Pindai Qr Code Absensi'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData != null && !isNavigating) {
        // Check the flag
        setState(() {
          result = scanData;
        });

        // Set the flag to true to prevent multiple navigations
        isNavigating = true;

        // Navigate to another screen with the scanned QR code value
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => luardinasambil(
                result!.code.toString()), // Replace with your screen
          ),
        ).then((_) {
          // Reset the flag after returning from the navigation
          isNavigating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

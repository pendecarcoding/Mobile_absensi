import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../theme/colors/light_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:asn1lib/asn1lib.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/api.dart' as pointycastle;

class luardinasambil extends StatefulWidget {
  final String scannedValue;

  luardinasambil(this.scannedValue);
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  @override
  State<luardinasambil> createState() => _luardinasambil();
}

class _luardinasambil extends State<luardinasambil> {
  String namaTempat = "Lapangan Tugu";
  String startTgl = "2023-08-22 12:00:00"; // Replace with your start date
  String endTgl = "2023-08-22 15:00:00";
  bool isLoading = false; // Replace with your end date
  bool countdownEnded = false;
  String hasildecrypt = "";
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');
  late pointycastle.AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;
  late RSAPrivateKey privateKey;
  @override
  void initState() {
    super.initState();

    loadPrivateKey();
    // You can add initialization logic here
  }

  Future<void> loadPrivateKey() async {
    final privateKeyPEM = await rootBundle.loadString('assets/private_key.pem');
    final privateKey = parsePrivateKeyFromPEM(privateKeyPEM);
    setState(() {
      this.privateKey = privateKey!;
    });
  }

  RSAPrivateKey? parsePrivateKeyFromPEM(String pemString) {
    final parser = RSAKeyParser();
    final keyBytes = Uint8List.fromList(pemString.codeUnits);
    final asn1Parser = ASN1Parser(keyBytes);
    final keyPair = parser.parse(asn1Parser as String);

    if (keyPair is RSAPrivateKey) {
      return keyPair;
    }

    return null;
  }

  Future<String> decryptData(String scannedValue) async {
    final cipher = OAEPEncoding(RSAEngine());
    cipher.init(
        false, pointycastle.PrivateKeyParameter<RSAPrivateKey>(privateKey));

    final encryptedBytes = base64.decode(scannedValue);
    final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
    final decryptedText = utf8.decode(decryptedBytes);

    return decryptedText;
  }

  void handleCountdownEnd() {
    // Delay execution by 1 millisecond to ensure it's after the build
    Future.delayed(Duration(milliseconds: 1), () {
      setState(() {
        countdownEnded = true; // Set the countdown flag when the timer ends
      });
      // You can add your logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Lokasi"),
        backgroundColor: LightColors.primary,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Center(
                  child: QrImage(
                    data: widget.scannedValue, // Set the QR code data
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
                SizedBox(height: 20),
                Text("Nama Tempat: $namaTempat",
                    style: TextStyle(fontSize: 18)),
                Text(
                  "Masa Berlaku QR Code: ${dateFormat.format(DateTime.parse(startTgl))} s/d ${dateFormat.format(DateTime.parse(endTgl))}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                if (privateKey != null)
                  FutureBuilder<String>(
                    future: decryptData(widget.scannedValue),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Decryption Error');
                      } else if (snapshot.hasData) {
                        return Text(
                          'Decrypted Data:\n${snapshot.data}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                Center(
                  child: CountdownTimer(
                    endTime: DateTime.parse(endTgl).millisecondsSinceEpoch,
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    onEnd: handleCountdownEnd,
                  ),
                ),
                SizedBox(height: 20),
                if (!countdownEnded)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: LightColors.primary,
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Adjust the radius value to your preference
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white))
                              : SizedBox(),
                          if (!isLoading)
                            Text(
                              'Ambil Absen',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      onPressed: () {
                        // check();
                      }, // Disable the button when loading
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

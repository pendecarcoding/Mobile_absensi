import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:absensi/screens/home/home.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
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
import 'package:pointycastle/api.dart' as pointycastle;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../view_model/absensi/AbsensiVM.dart';
import 'package:trust_location/trust_location.dart';

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
  late String tgl_akhir = "";
  late String tgl_mulai = "";
  bool isLoading = false; // Replace with your end date
  bool bisaabsen = false; // Replace with your end date
  bool countdownEnded = false;
  String hasildecrypt = "";
  String? id_luarkantor;
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');
  late pointycastle.AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;
  late final RSAPrivateKey privateKey;
  DateTime currentDateTime = DateTime.now();
  DateTime? tglMulaiDateTime;
  double currentlatitude = 0.0;
  double currentlongitude = 0.0;
  double locationlatitude = 0.0;
  double locationlongitude = 0.0;
  int? radius;
  File? imageFile;
  final AbsensiVM absensiModel = AbsensiVM();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = FlutterSecureStorage();
  bool? _isMockLocation;
  @override
  initState() {
    super.initState();
    TrustLocation.start(5);
    _initializeState();
    _getCurrentLocation();
    // _checkGPSOrigin();

    // You can add initialization logic here
  }

  void openGoogleMapsRoute(
      double startLat, double startLng, double endLat, double endLng) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies permission
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      TrustLocation.onChange.listen((values) => setState(() {
            currentlatitude = double.parse(values.latitude!);
            currentlongitude = double.parse(values.longitude!);
            _isMockLocation = values.isMockLocation;
            if (_isMockLocation!) {
              _fakeGPS(context);
            }
          }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }

    setState(() {
      currentlatitude = position.latitude;
      currentlongitude = position.longitude;
    });
  }

  ambilabsen() {
    double distance = calculateDistance(
        locationlatitude, locationlongitude, currentlatitude, currentlongitude);

    String distanceText;

    if (distance >= 1000) {
      double distanceInKilometers = distance / 1000;
      distanceText = '${distanceInKilometers.toStringAsFixed(2)} km';
    } else {
      distanceText = '${distance.toStringAsFixed(2)} meters';
    }
    if (distance.toInt() <= radius!) {
      print("BISA");
      bisaabsen = true;
      openCamera(context);
    } else {
      print("TIDAK");
      bisaabsen = false;
      _dialogNotOnRadius(context);
    }
  }

  void updateTglAkhir(String newTglAkhir) {
    setState(() {
      tgl_akhir = newTglAkhir;
    });
  }

  Widget updateCountdownTimer() {
    DateTime endTime = DateTime.parse(tgl_akhir);
    Duration remainingTime = endTime.difference(DateTime.now());
    var colortime = Colors.black;
    setState(() {
      colortime = remainingTime.inMinutes < 1 ? Colors.red : Colors.black;
    });
    return CountdownTimer(
      endTime: DateTime.parse(tgl_akhir).millisecondsSinceEpoch,
      textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: colortime, // Ubah warna menjadi merah jika kurang dari 1 menit
      ),
      onEnd: handleCountdownEnd,
    );
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const int radiusOfEarth = 6371000; // meters (approximate)

    double lat1 = startLatitude * (math.pi / 180.0);
    double lon1 = startLongitude * (math.pi / 180.0);
    double lat2 = endLatitude * (math.pi / 180.0);
    double lon2 = endLongitude * (math.pi / 180.0);

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a = math.sin(dlat / 2) * math.sin(dlat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dlon / 2) *
            math.sin(dlon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return radiusOfEarth * c;
  }

  Future<void> _initializeState() async {
    await _loadPrivateKey().then((key) {
      setState(() {
        privateKey = key; // Assign the loaded private key
      });
    }); // Wait for the private key to be loaded
    // You can add other initialization logic here
  }

  Future<String> decryptRSA(
      String encryptedData, RSAPrivateKey privateKey) async {
    final cipher = RSAEngine()
      ..init(
        true,
        pointycastle.PrivateKeyParameter<RSAPrivateKey>(privateKey),
      );

    final encryptedBytes = Base64Decoder().convert(encryptedData);
    var decryptedText;
    if (encryptedBytes != null) {
      final decryptedBytes = cipher.process(encryptedBytes);
      decryptedText = String.fromCharCodes(decryptedBytes);
      List<String> parts = decryptedText.split("BOY_CHIPER|");
      if (parts.length > 1) {
        String result = parts[1]; // Select the part after "BOY_CHIPER|"
        decryptedText = result;
        List<String> part = result!.split("|");
        setState(() {
          namaTempat = part[0];
          tgl_akhir = part[2];
          tgl_mulai = part[1];
          tglMulaiDateTime = DateTime.parse(tgl_mulai);
          locationlatitude = double.parse(part[3]);
          locationlongitude = double.parse(part[4]);
          id_luarkantor = part[6];
          radius = int.parse(part[5]);
        });
      }
    } else {
      SystemNavigator.pop();
    }

    return decryptedText;
  }

  void openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final File? imagefile = File(image!.path);
    setState(() async {
      dynamic id = await SessionManager().get("id");
      final bytes = io.File(image.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      uploadAbsen(id.toString(), currentlatitude.toString(),
          currentlongitude.toString(), 'H', img64, 'LK', id_luarkantor!);
    });
  }

  void uploadAbsen(
    String id,
    String currentLat,
    String currentLong,
    String status,
    String img64,
    String jenis,
    String id_luarkantor,
  ) async {
    await absensiModel
        .addabsensiluarkantor(id, currentLat, currentLong, 'H',
            "data:image/png;base64," + img64, jenis, id_luarkantor)
        .then((success) {
      if (success) {
        print("MOGA MASUK");
        _showSuccessSnackbar();
      } else {
        print("Operation failed");
        // Handle failure
      }
    });
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data sent successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => home()), // Replace with your desired activity
      );
    });
  }

  void _dialogTake(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: const Text(
            'Tetap pada posisi anda saat ini untuk melakukan proses absensi',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Oke. Ambil Swa Foto'),
              onPressed: () async {
                Navigator.of(context).pop();
                openCamera(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _fakeGPS(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: Text(
            'Tampaknya anda menggunakan GPS palsu. saat menggunakan GPS palsu anda tidak akan dapat melakukan Absensi',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Mengerti'),
              onPressed: () {
                SystemNavigator.pop(); // Menutup aplikasi
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkGPSOrigin() async {
    final originalLatitude = await storage.read(key: 'originalLatitude');
    final originalLongitude = await storage.read(key: 'originalLongitude');

    if (originalLatitude != null && originalLongitude != null) {
      _fakeGPS(context);
    } else {
      // Store the current GPS data as original GPS data
      await storage.write(
        key: 'originalLatitude',
        value: currentlatitude.toString(),
      );
      await storage.write(
        key: 'originalLongitude',
        value: currentlongitude.toString(),
      );
    }
  }

  void _dialogNotOnRadius(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: Text(
            'Saat ini anda di luar dari area Absensi !!! untuk melakukan absensi pastikan anda masuk dalam lokasi ${namaTempat}. untuk radius absensi berkisar ${radius.toString()} Meter',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Lihat Lokasi Absen'),
              onPressed: () {
                openGoogleMapsRoute(currentlatitude, currentlongitude,
                    locationlatitude, locationlongitude);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  RSAPrivateKey? parsePrivateKeyFromPEM(String pemString) {
    final parser = RSAKeyParser();
    final keyBytes = Uint8List.fromList(pemString.codeUnits);
    final asn1Parser = ASN1Parser(keyBytes);
    final keyPair = parser.parse(asn1Parser.toString());

    if (keyPair is RSAPrivateKey) {
      return keyPair;
    }

    return null;
  }

  Future<RSAPrivateKey> _loadPrivateKey() async {
    final privateKeyPEM = await rootBundle.loadString('assets/private_key.pem');
    final parser = RSAKeyParser();
    final privateKey = parser.parse(privateKeyPEM) as RSAPrivateKey;
    return privateKey;
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
      key: _scaffoldKey,
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
                FutureBuilder<String>(
                  future: decryptRSA(widget.scannedValue, privateKey),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Decryption Error');
                    } else if (snapshot.hasData) {
                      List<String> parts = snapshot.data!.split("|");
                      String tempat = parts[0];
                      String tgl_mulai = parts[1];
                      String newTglAkhir =
                          parts[2]; // Ambil nilai baru dari snapshot
                      tgl_akhir = newTglAkhir;
                      // Memperbarui nilai tgl_akhir

                      return Container(
                        child: Column(
                          children: [
                            Text("Nama Tempat: $tempat",
                                style: TextStyle(fontSize: 18)),
                            Text(
                              "Masa Berlaku QR Code: ${dateFormat.format(DateTime.parse(tgl_mulai))} s/d ${dateFormat.format(DateTime.parse(tgl_akhir))}",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      );

                      // Text(
                      //   'Decrypted Data:\n${snapshot.data}',
                      //   style: TextStyle(fontSize: 18),
                      //   textAlign: TextAlign.center,
                      // );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                if (currentDateTime!.isAfter(tglMulaiDateTime!))
                  Center(child: updateCountdownTimer()),
                if (currentDateTime!.isBefore(tglMulaiDateTime!))
                  Text("Status : Belum Mulai"),
                SizedBox(height: 20),
                if (!countdownEnded &&
                    currentDateTime!.isAfter(tglMulaiDateTime!))
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
                        ambilabsen();
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

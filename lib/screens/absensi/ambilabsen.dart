import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:absensi/model/login/LoginModel.dart';
import 'package:absensi/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';

import '../../data/remote/response/Status.dart';
import '../../theme/colors/light_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

import '../../view_model/absensi/AbsensiVM.dart';
import '../../view_model/login/LoginVM.dart';
import '../login/login.dart';
import '../widget/LoadingWidget.dart';
import '../widget/MyErrorWidget.dart';
import 'package:back_pressed/back_pressed.dart';
import 'package:vibration/vibration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  var firstCamera = cameras.first;
}

class ambilabsen extends StatefulWidget {
  @override
  State<ambilabsen> createState() => _ambilabsen();
}

class _ambilabsen extends State<ambilabsen> {
  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  String geofenceStatus = '';
  double distance = 0.0;
  Timer? timer;
  File? imageFile;
  String currentLat = '';
  String currentLong = '';
  String jenis = '';
  final LoginVM viewModel = LoginVM();
  final AbsensiVM absensiModel = AbsensiVM();
  @override
  void dispose() {
    timer
        ?.cancel(); // Cancel the timer to prevent calling setState after dispose
    geofenceStatusStream
        ?.cancel(); // Also cancel the geofenceStatusStream if necessary
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
    getdata();
  }

  @override
  void deactivate() {
    timer?.cancel();
    geofenceStatusStream?.cancel();
    super.deactivate();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    double lati2 = double.parse(lat2);
    double lonn2 = double.parse(lon2);
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lati2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lati2 * p) * (1 - cos((lonn2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void getdistance(Kantor kantor) {
    try {
      getUserCurrentLocation().then((value) async {
        var totalDistance = await calculateDistance(
          value.latitude,
          value.longitude,
          kantor.latitude,
          kantor.longitude,
        );
        setState(() {
          currentLat = value.latitude.toString();
          currentLong = value.longitude.toString();
          distance = totalDistance;
          checkStatus();
        });
      });
    } catch (e) {}
  }

  void checkStatus() {
    if (geofenceStatusStream == null) {
      geofenceStatusStream = EasyGeofencing.getGeofenceStream()!.listen(
        (GeofenceStatus status) {
          print("GEOFENCE " + status.toString());
          setState(() {
            if (status.toString() == "GeofenceStatus.enter") {
              geofenceStatus = "VALID";
            } else {
              geofenceStatus = "INVALID";
              _vibratePhone();
            }
          });
        },
      );
    }
  }

  Future<void> _vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [
        500,
        1000,
      ]); // Vibrate for 500ms, pause for 1000ms, then repeat.
    }
  }

  void startGeofencing(Kantor kantor) {
    EasyGeofencing.startGeofenceService(
      pointedLatitude: kantor.latitude!,
      pointedLongitude: kantor.longitude!,
      radiusMeter: kantor.radius.toString(),
      eventPeriodInSeconds: 1,
    );
  }

  void openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final File? imagefile = File(image!.path);
    setState(() async {
      dynamic id = await SessionManager().get("id");
      final bytes = io.File(image.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      uploadAbsen(
        id.toString(),
        currentLat,
        currentLong,
        'H',
        img64,
        jenis,
      );
    });
  }

  void uploadAbsen(
    String id,
    String currentLat,
    String currentLong,
    String status,
    String img64,
    String jenis,
  ) async {
    await absensiModel
        .addabsensi(
      id,
      currentLat,
      currentLong,
      'H',
      "data:image/png;base64," + img64,
      jenis,
    )
        .then((value) {
      print("MOGA MASUK");
    });
  }

  message(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Absensi Berhasil dilakukan"),
      ),
    );
  }

  void _dialogTake(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: const Text(
            'Tetap pada posisi anda saat ini untuk melakukan proses absensi. jangan berpindah keluar batas dari lingkaran radius. saran terbaik saat ini anda tetap di lokasi VALID, Pindah kelokasi INVALID akan membuat proses absensi ditolak',
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

  void _dialogNotOnRadius(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: const Text(
            'Saat ini anda di luar dari area Absensi !!! untuk melakukan absensi pastikan anda masuk dalam radius kantor',
          ),
          actions: <Widget>[
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

  void getdata() async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      await viewModel.DetailAccount(id.toString());
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => login(),
        ),
      );
    }
  }

  Widget _buildSudahAbsen(List<Listabsen>? listAbsen) {
    return ListView.builder(
      itemCount: listAbsen?.length,
      itemBuilder: (context, position) {
        return _buildAbsenListItem(listAbsen![position]);
      },
    );
  }

  Widget _buildAbsenListItem(Listabsen item) {
    return GestureDetector(
      onTap: () {
        // ... (navigate to detailpegawai or any other logic)
      },
      child: Card(
        margin: EdgeInsets.only(top: 2),
        child: ListTile(
          title: Text(item.tglabsen.toString()),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Latitude :" + item.latitude!),
              Text("Longitude :" + item.longitude!),
              Text("Waktu Absen :" + item.time!),
              Text("Status :" +
                  ((item.status.toString() == 'H') ? "HADIR" : "")),
              Text(
                "Jenis Absen :" +
                    ((item.jenis.toString() == 'M')
                        ? "ABSEN MASUK"
                        : "ABSEN PULANG"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildData(Kantor kantor, Data pegawai, Jam jam) {
    getUserCurrentLocation();
    timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) => getdistance(kantor),
    );
    startGeofencing(kantor);
    double latitudekantor = double.parse(kantor.latitude.toString());
    double longitudekantor = double.parse(kantor.longitude.toString());
    String namaunitkerja = kantor.namaunitkerja.toString();
    if (jam.jenis == "Jam Masuk") {
      jenis = 'M';
      print("Jenis Absen :" + jenis);
    } else {
      jenis = 'P';
      print("Jenis Absen :" + jenis);
    }
    Set<Circle> circles = Set.from([
      Circle(
        strokeColor: Colors.amber,
        strokeWidth: 5,
        circleId: CircleId("kantor"),
        center: LatLng(latitudekantor, longitudekantor),
        radius: double.parse(kantor.radius.toString()),
        fillColor: Color.fromARGB(69, 64, 156, 112),
      ),
    ]);
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.terrain,
            circles: circles,
            markers: {
              Marker(
                markerId: MarkerId(namaunitkerja),
                position: LatLng(latitudekantor, longitudekantor),
                draggable: false,
                onDragEnd: (value) {
                  // value is the new position
                },
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: namaunitkerja,
                  snippet: "Pastikan anda berada dilokasi radius",
                ),
              ),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(latitudekantor, longitudekantor),
              zoom: 25.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(top: 10, bottom: 7, left: 20, right: 60),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://absensi.bengkaliskab.go.id/pegawai/" +
                            pegawai.kodeUnitkerja! +
                            "/" +
                            pegawai.image!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        pegawai.nama!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Jarak Lokasi Kantor : " +
                            distance.toStringAsFixed(2) +
                            " KM",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 218, 2, 2),
                        ),
                      ),
                      Text(
                        "Status Lokasi : " + geofenceStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 96, 91, 91),
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  child: Center(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 242, 242, 242),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.fingerprint),
                        color: Color.fromARGB(255, 7, 7, 7),
                        onPressed: () {
                          if (geofenceStatus == 'VALID') {
                            _dialogTake(context);
                          } else {
                            _dialogNotOnRadius(context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Any action you want to perform before going back to the parent activity

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        home())); // This will finish the child activity and return to the parent activity
          },
        ),
        title: Text("Ambil Absen"),
        backgroundColor: LightColors.primary,
      ),
      body: ChangeNotifierProvider<LoginVM>(
        create: (BuildContext context) => viewModel,
        child: Consumer<LoginVM>(
          builder: (context, viewModel, _) {
            switch (viewModel.login.status) {
              case Status.LOADING:
                return LoadingWidget();
              case Status.ERROR:
                return MyErrorWidget(viewModel.login.message ?? "NA");
              case Status.COMPLETED:
                if (viewModel.login.data!.bisaabsen! == 'yes') {
                  return _buildData(
                    viewModel.login.data!.kantor!,
                    viewModel.login.data!.data!,
                    viewModel.login.data!.jam!,
                  );
                } else {
                  if (viewModel.login.data!.listabsen!.isNotEmpty) {
                    return _buildSudahAbsen(viewModel.login.data!.listabsen!);
                  } else {
                    return Center(
                      child: Text("Hari ini tidak ada kewajiban untuk absen"),
                    );
                  }
                }

              default:
            }
            return Container();
          },
        ),
      ),
    );
  }
}

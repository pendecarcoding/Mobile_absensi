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

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  var firstCamera = cameras.first;
}

class ambilabsen extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  @override
  State<ambilabsen> createState() => _ambilabsen();
}

class _ambilabsen extends State<ambilabsen> {
  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  String geofenceStatus = '';
  //String latitudekantor = kantor.latitude;
  bool isReady = false;
  double distance = 0.0;
  Timer? timer;
  File? imageFile;
  String currentlat = '';
  String currentlot = '';
  String jenis = '';
  final LoginVM viewModel = LoginVM();
  final AbsensiVM absensiModel = AbsensiVM();
  void openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final File? imagefile = File(image!.path);
    setState(() async {
      dynamic id = await SessionManager().get("id");
      //imageFile = File(image.path);
      final bytes = io.File(image.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      uploadabsen(id.toString(), currentlat, currentlot, 'H', img64, jenis);
    });
  }

  uploadabsen(id, String currentlat, String currentlot, String status,
      String img64, String jenis) async {
    await absensiModel
        .addabsensi(id, currentlat, currentlot, 'H',
            "data:image/png;base64," + img64, jenis)
        .then((value) {
      print("MOGA MASUK");
    });
  }

  message(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Absensi Berhasil dilakukan"),
    ));
  }

  _dialogtake(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: const Text(
              'Tetap pada posisi anda saat ini untuk melakukan proses absensi. jangan berpindah keluar batas dari lingkaran radius. saran terbaik saat ini anda tetap di lokasi VALID, Pindah kelokasi INVALID akan membuat proses absensi ditolak'),
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

  _dialognotonradius(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: const Text(
              'Saat ini anda di luar dari area Absensi !!! untuk melakukan absensi pastikan anda masuk dalam radius kantor'),
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

  @override
  void initState() {
    getdata();
    getUserCurrentLocation();
    super.initState();
  }

  getdata() async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      await viewModel.DetailAccount(id.toString());
      // print(viewpegawai.data.data!.data!.first.nama!);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => login()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
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

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  /*static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.4675412812283035, 102.11088212389),
    zoom: 25.4746,
  );*/

  /*Set<Circle> circles = Set.from([
    Circle(
        strokeColor: Colors.amber,
        strokeWidth: 5,
        circleId: CircleId("kantor"),
        center: LatLng(1.4675412812283035, 102.11088212389),
        radius: 10,
        fillColor: Color.fromARGB(69, 64, 156, 112))
  ]);*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnBackPressed(
            perform: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const home()),
              );
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text("Ambil Absen"),
              ),
              body: ChangeNotifierProvider<LoginVM>(
                  create: (BuildContext context) => viewModel,
                  child: Consumer<LoginVM>(builder: (context, viewModel, _) {
                    switch (viewModel.login.status) {
                      case Status.LOADING:
                        return LoadingWidget();
                      case Status.ERROR:
                        return MyErrorWidget(viewModel.login.message ?? "NA");
                      case Status.COMPLETED:
                        if (viewModel.login.data!.bisaabsen! == 'yes') {
                          return getData(
                              viewModel.login.data!.kantor!,
                              viewModel.login.data!.data!,
                              viewModel.login.data!.jam!);
                        } else {
                          if (viewModel.login.data!.listabsen!.isNotEmpty) {
                            return SudahAbsen(viewModel.login.data!.listabsen!);
                          } else {
                            return Center(
                              child: Text(
                                  "Hari ini tidak ada kewajiban untuk absen"),
                            );
                          }
                        }

                      default:
                    }
                    return Container();
                  })),

              /* floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Ambil Absen'),
        icon: const Icon(Icons.directions_boat),
      ),*/
            )));
  }

  Widget SudahAbsen(List<Listabsen>? Listabsen) {
    return ListView.builder(
        itemCount: Listabsen?.length,
        itemBuilder: (context, position) {
          return _getAbsenListItem(Listabsen![position]);
        });
  }

  Widget _getAbsenListItem(Listabsen item) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detailpegawai(
                /*idkelas: item.idKelas!,
                idsekolah: item.idSekolahsiswa!,
                nis: item.nis*/
                ),
          ),
        );*/
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
              Text("Jenis Absen :" +
                  ((item.jenis.toString() == 'M')
                      ? "ABSEN MASUK"
                      : "ABSEN PULANG")),
            ],
          ),
        ),
      ),
    );
  }

  getData(Kantor kantor, Data pegawai, Jam jam) {
    getUserCurrentLocation();
    timer =
        Timer.periodic(Duration(seconds: 2), (Timer t) => getdistance(kantor));
    startGeofenching(kantor);
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
          fillColor: Color.fromARGB(69, 64, 156, 112))
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
                      snippet: "Pastikan anda berada dilokasi radius")),
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
                      offset: Offset.zero)
                ]),
            child: Row(children: [
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
                                pegawai.image!),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    pegawai.nama!,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  Text(
                    textAlign: TextAlign.left,
                    "Jarak Lokasi Kantor : " +
                        distance.toStringAsFixed(2) +
                        " KM",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 218, 2, 2)),
                  ),
                  Text(
                    textAlign: TextAlign.left,
                    "Status Lokasi : " + geofenceStatus,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 96, 91, 91)),
                  ),
                ],
              )),
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
                          //ambilabsen();
                          _dialogtake(context);
                        } else {
                          //ambilabsen();
                          _dialognotonradius(context);
                        }
                      },
                    ),
                  ),
                ),
              )
            ]),
          ),
        )
      ],
    );
  }

  void getdistance(Kantor kantor) {
    try {
      getUserCurrentLocation().then((value) async {
        var totalDistance = await calculateDistance(
            value.latitude, value.longitude, kantor.latitude, kantor.longitude);
        setState(() {
          currentlat = value.latitude.toString();
          currentlot = value.longitude.toString();
          distance = totalDistance;
          checkstatus();
        });
      });
    } catch (e) {}
  }

  void checkstatus() {
    if (geofenceStatusStream == null) {
      geofenceStatusStream =
          EasyGeofencing.getGeofenceStream()!.listen((GeofenceStatus status) {
        print("GEOFENCE " + status.toString());
        setState(() {
          if (status.toString() == "GeofenceStatus.enter") {
            geofenceStatus = "VALID";
          } else {
            geofenceStatus = "INVALID";
          }
        });
      });
    }
  }
}

void startGeofenching(Kantor kantor) {
  EasyGeofencing.startGeofenceService(
      pointedLatitude: kantor.latitude!,
      pointedLongitude: kantor.longitude!,
      radiusMeter: kantor.radius.toString(),
      eventPeriodInSeconds: 1);
}

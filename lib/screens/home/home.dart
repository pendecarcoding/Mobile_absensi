import 'dart:async';

import 'package:absensi/model/login/LoginModel.dart';
import 'package:absensi/screens/absensi/ambilabsen.dart';
import 'package:absensi/screens/absensi/luardinas.dart';
import 'package:absensi/screens/datapegawai/datapegawai.dart';
import 'package:absensi/screens/webview/ekinerja.dart';
import 'package:absensi/screens/widget/nointernet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../data/remote/response/Status.dart';
import '../../theme/colors/light_colors.dart';
import '../../view_model/PegawaiVM.dart';
import '../../view_model/login/LoginVM.dart';
import '../../widgets/home/task_column.dart';
import '../../widgets/home/top_container.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../bantuan/bantuan.dart';
import '../cuti/cuti.dart';
import '../dinas/dinas.dart';
import '../login/login.dart';
import '../profil/profil.dart';
import '../widget/LoadingWidget.dart';
import '../widget/MyErrorWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trust_location/trust_location.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _home();
  //Test
}

class _home extends State<home> {
  final LoginVM viewModel = LoginVM();
  final PegawaiVM viewpegawai = PegawaiVM();
  late DateFormat dateFormat;
  double currentlatitude = 0.0;
  double currentlongitude = 0.0;
  double locationlatitude = 0.0;
  double locationlongitude = 0.0;
  final storage = FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Get the FCM token

  Timer? timer;
  String? nama = '';
  bool? _isMockLocation;

  get width => null;
  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat('EEEE, d MMMM yyyy', 'id');
    getdata();
    TrustLocation.start(5);
    _getCurrentLocation();
    //
    timer?.cancel();
    _subscribeToTopic();
    super.initState();
  }

  void _subscribeToTopic() {
    _firebaseMessaging.subscribeToTopic('NOTIFPEGAWAI');
    print('Subscribed to topic!');
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

  _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies permission
        return;
      }
    }

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
  }

  getdata() async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      await viewModel.DetailAccount(id.toString());
      await viewpegawai.getdata(
          id.toString(), viewModel.login.data!.data!.kodeUnitkerja!, '');
      // print(viewpegawai.data.data!.data!.first.nama!);
      print(id);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => login()));
    }
  }

  Future<void> _dialoglogout(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apakah anda yakin akan keluar Aplikasi ?'),
          content: const Text(
              'Jika iya tekan YA jika tidak tekan TIDAK, Jika Logout anda harus login kembali jika akan menggunakan Aplikasi'),
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
              child: const Text('Ya'),
              onPressed: () async {
                await SessionManager().remove("id").then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => login()),
                        ModalRoute.withName('/')));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: LightColors.primary,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.qr_code),
              tooltip: 'Absen Luar Kantor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => luardinas()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.message),
              color: Colors.white,
              tooltip: 'Message',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bantuan()),
                );
              },
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                _dialoglogout(context);
              },
            ),
          ]),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<LoginVM>(
          create: (BuildContext context) => viewModel,
          child: Consumer<LoginVM>(builder: (context, viewModel, _) {
            switch (viewModel.login.status) {
              case Status.LOADING:
                return LoadingWidget();
              case Status.ERROR:
                if (viewModel.login.message ==
                    'Error During Communication: No Internet Connection') {
                  return Nointernet();
                } else {
                  return MyErrorWidget(viewModel.login.message ?? "NA");
                }

              case Status.COMPLETED:
                return getDataHome(
                    viewModel.login.data!.data!,
                    viewModel.login.data!.kantor!,
                    viewModel.login.data!.bisaabsen,
                    viewModel.login.data!.jam!);
              default:
            }
            return Container();
          })),
    );
  }

  Widget getDataHome(Data data, Kantor kantor, String? bisaabsen, Jam jam) {
    double kantorlatitude = double.parse(kantor.latitude.toString());
    double kantorlongitude = double.parse(kantor.longitude.toString());
    return SingleChildScrollView(
        child: Container(
            child: Column(
      children: <Widget>[
        Container(
          height: 260,
          child: Stack(children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: TopContainer(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(0),
                    warna: LightColors.primary,
                    child: Column(children: <Widget>[
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 20, left: 10),
                              child: CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 5.0,
                                animation: true,
                                percent: 0.75,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                backgroundColor:
                                    Color.fromARGB(255, 243, 206, 137),
                                center: CircleAvatar(
                                  backgroundColor: LightColors.kBlue,
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(
                                      "https://absensi.bengkaliskab.go.id/pegawai/" +
                                          data.kodeUnitkerja! +
                                          "/" +
                                          data.image!),
                                ),
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 20, left: 10),
                                    child: Text(
                                      data.nama!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "NIP : " + data.nip!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      data.email!,
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                      softWrap: false,
                                      maxLines: 2,
                                      overflow: TextOverflow.fade, //new
                                    ),
                                  ),
                                ]),
                          ])
                    ]))),
            Positioned(
              top: 150,
              left: 2,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 63, 63, 63).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                margin: EdgeInsets.only(left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: new Text(
                      dateFormat.format(DateTime.now()),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 96, 96, 96)),
                    )),
                  ),
                  Expanded(
  flex: 1, // You can adjust the flex value as per your layout needs
  child: IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Column(
            children: [
              Center(
                child: Text(
                  (jam.jam! != null) ? jam.jam! : "--:--",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "MULAI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(
          color: LightColors.kRed, //color of divider
          width: 10, //width space of divider
          thickness: 3, //thickness of divier line
          indent: 10, //Spacing at the top of divider.
          endIndent: 10, //Spacing at the bottom of divider.
        ),
        Container(
          child: Column(
            children: [
              Center(
                child: Text(
                  (jam.batas! != null) ? jam.batas! : "--:--",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "AKHIR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)

                ]),
              ),
            ),
          ]),
        ),
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  subheading('Informasi '),
                  GestureDetector(
                    onTap: () {},
                    child: calendarIcon(data),
                  ),
                ],
              ),
              /*SizedBox(height: 15.0),
                        TaskColumn(
                          widget: home(),
                          jenis: 'url',
                          url: '',
                          icon: Icons.person,
                          iconBackgroundColor: LightColors.kRed,
                          title: 'Total Santri',
                          subtitle: 'Total Santri Aktif',
                        ),*/
              SizedBox(
                height: 15.0,
              ),
              TaskColumn(
                widget: home(),
                jenis: "googlemaps",
                url:
                    "https://www.google.com/maps/dir/?api=1&origin=$currentlatitude,$currentlongitude&destination=$kantorlatitude,$kantorlongitude&travelmode=driving",
                icon: Icons.maps_home_work_sharp,
                iconBackgroundColor: LightColors.kDarkYellow,
                title: 'Lokasi Kantor',
                subtitle: 'Klick untuk membuka Peta',
              ),
              SizedBox(height: 15.0),
              TaskColumn(
                widget: datapegawai(
                    kodeunitkerja: viewModel.login.data!.data!.kodeUnitkerja!),
                jenis: 'route',
                url: '',
                icon: Icons.account_box,
                iconBackgroundColor: LightColors.kBlue,
                title: 'Data Pegawai',
                subtitle: 'lihat daftar Pegawai Kantor',
              ),
              SizedBox(height: 15.0),
              TaskColumn(
                widget: ekinerja(),
                jenis: 'route',
                url: '',
                icon: Icons.laptop,
                iconBackgroundColor: Color.fromARGB(255, 224, 49, 130),
                title: 'E-KINERJA',
                subtitle: 'Aplikasi E-Kinerja BKN',
              ),
              // TaskColumn(
              //   widget: datapegawai(
              //       kodeunitkerja: viewModel.login.data!.data!.kodeUnitkerja!),
              //   jenis: 'route',
              //   url: '',
              //   icon: Icons.pie_chart,
              //   iconBackgroundColor: LightColors.kRed,
              //   title: 'Persentase Kehadiran',
              //   subtitle: 'lihat persentase kehadiran anda',
              // ),
            ],
          ),
        ),
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              subheading('Fitur Absen'),
              SizedBox(height: 5.0),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => cuti(
                                id_pegawai:
                                    viewModel.login.data!.data!.idPegawai,
                                kodeunitkerja: viewModel
                                    .login.data!.data!.kodeUnitkerja)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: LightColors.kRed,
                  ),
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: LightColors.primary,
                    child: Icon(
                      Icons.calendar_month,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("Pengajuan Cuti"),
                  subtitle: Text("untuk pengurusan cuti pegawai"),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => dinas(
                                id_pegawai:
                                    viewModel.login.data!.data!.idPegawai,
                                kodeunitkerja: viewModel
                                    .login.data!.data!.kodeUnitkerja)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: LightColors.kRed,
                  ),
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: LightColors.primary,
                    child: Icon(
                      Icons.car_crash_outlined,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("Pengajuan Izin Dinas"),
                  subtitle: Text("untuk pengurusan izin Dinas"),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ambilabsen(
                                kantor: viewModel.login.data!.kantor!)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: LightColors.kRed,
                  ),
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: LightColors.primary,
                    child: Icon(
                      Icons.face_rounded,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("Ambil Absen"),
                  subtitle: Text("fitur untuk melakukan absensi"),
                ),
              )
            ],
          ),
        ),
      ],
    )));
  }

  GestureDetector calendarIcon(Data data) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => profil(data),
          ),
        ).whenComplete(() => {getdata()});
      },
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: LightColors.primary,
        child: Icon(
          Icons.settings,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Color.fromARGB(255, 42, 85, 132),
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }
}

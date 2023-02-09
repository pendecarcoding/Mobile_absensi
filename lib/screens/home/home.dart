import 'package:absensi/model/login/LoginModel.dart';
import 'package:absensi/screens/absensi/ambilabsen.dart';
import 'package:absensi/screens/datapegawai/datapegawai.dart';
import 'package:absensi/screens/widget/nointernet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../data/remote/response/Status.dart';
import '../../theme/colors/light_colors.dart';
import '../../view_model/PegawaiVM.dart';
import '../../view_model/login/LoginVM.dart';
import '../../widgets/home/task_column.dart';
import '../../widgets/home/top_container.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import '../widget/LoadingWidget.dart';
import '../widget/MyErrorWidget.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _home();
  //Test
}

class _home extends State<home> {
  final LoginVM viewModel = LoginVM();
  final PegawaiVM viewpegawai = PegawaiVM();
  String? nama = '';

  get width => null;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      await viewModel.DetailAccount(id.toString());
      await viewpegawai.getdata(
          id.toString(), viewModel.login.data!.data!.kodeUnitkerja!);
      // print(viewpegawai.data.data!.data!.first.nama!);
      print(viewModel.login.data!.data!.kodeUnitkerja!);
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
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 42, 42, 42),
            ),
            onPressed: () {
              _dialoglogout(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Color.fromARGB(255, 42, 42, 42),
            ),
            onPressed: () {
              _dialoglogout(context);
            },
          )
        ],
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "Aplikasi Absensi",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 42, 42, 42)),
        ),
        elevation: 0.3,
      ),
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
                    viewModel.login.data!.data!, viewModel.login.data!.kantor!);
              default:
            }
            return Container();
          })),
    );
  }

  Widget getDataHome(Data data, Kantor kantor) {
    return Container(
        //color: Color.fromARGB(66, 152, 170, 194),
        child: ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        Container(
          child: Column(children: <Widget>[
            TopContainer(
                height: 120,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
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
                            progressColor: Color.fromARGB(255, 255, 255, 255),
                            backgroundColor: Color.fromARGB(255, 243, 206, 137),
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
                                    color: Color.fromARGB(255, 55, 55, 77),
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
                                    color: Color.fromARGB(255, 55, 55, 77),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  data.email!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 55, 55, 77)),
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade, //new
                                ),
                              ),
                            ]),
                      ])
                ])),
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      subheading('Absensi APP'),
                      GestureDetector(
                        onTap: () {},
                        child: calendarIcon(),
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
                    jenis: "url",
                    url: 'https://www.google.com/maps/search/?api=1&query=' +
                        kantor.latitude! +
                        ',' +
                        kantor.longitude!,
                    icon: Icons.maps_home_work_sharp,
                    iconBackgroundColor: LightColors.kDarkYellow,
                    title: 'Lokasi Kantor',
                    subtitle: 'Klick untuk membuka Peta',
                  ),
                  SizedBox(height: 15.0),
                  TaskColumn(
                    widget: datapegawai(
                        kodeunitkerja:
                            viewModel.login.data!.data!.kodeUnitkerja!),
                    jenis: 'route',
                    url: '',
                    icon: Icons.account_box,
                    iconBackgroundColor: LightColors.kBlue,
                    title: 'Data Pegawai',
                    subtitle: 'lihat daftar Pegawai Kantor',
                  ),
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
                  subheading('Fitur Aplikasi'),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          /* onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => spp(
                                            anak: viewModel.login.data!.anak),
                                      ),
                                    ),*/
                          child: Container(
                        child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1,
                            shadowColor: Colors.black,
                            color: Color.fromARGB(255, 1, 115, 222),
                            child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(children: [
                                      Icon(
                                        Icons.file_open,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Ambil Cuti",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ])))),
                      )),
                      GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ambilabsen()),
                              ),
                          child: Container(
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 1,
                                shadowColor: Colors.black,
                                color: Color.fromARGB(255, 222, 1, 97),
                                child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(children: [
                                          Icon(
                                            Icons.map,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Ambil Absen",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        ])))),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    ));
  }

  GestureDetector calendarIcon() {
    return GestureDetector(
      onTap: () async {
        /*await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => pengaturan(),
          ),
        ).whenComplete(() => {getdata()});*/
      },
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.amber,
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

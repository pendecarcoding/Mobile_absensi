import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../theme/colors/light_colors.dart';
import '../../widgets/home/task_column.dart';
import '../../widgets/home/top_container.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _home();
  //Test
}

class _home extends State<home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                //_dialoglogout(context);
              },
            )
          ],
          backgroundColor: LightColors.Blue,
          title: Text("Aplikasi Absensi"),
        ),
        backgroundColor: Colors.white,
        body: /*ChangeNotifierProvider<LoginVM>(
        create: (BuildContext context) => viewModel,
        child: 
        Consumer<LoginVM>(builder: (context, viewModel, _) {
          switch (viewModel.login.status) {
            case Status.LOADING:
              return LoadingWidget();
            case Status.ERROR:
              return MyErrorWidget(viewModel.login.message ?? "NA");
            case Status.COMPLETED:
              return getDataHome(viewModel.login.data!.data!);
            default:
          }
          return Container();
        })
      ),
    )*/

            getDataHome());
  }

  Widget getDataHome() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          TopContainer(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularPercentIndicator(
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
                                "https://jdih.bandungkab.go.id/asset/admin/dist/img/avatar04.png"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Bohati Mulyadi",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Jln. Kartini",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                          url:
                              'https://www.google.com/maps/search/?api=1&query=1.5058823,102.0624475',
                          icon: Icons.maps_home_work_sharp,
                          iconBackgroundColor: LightColors.kDarkYellow,
                          title: 'Lokasi Kantor',
                          subtitle: 'Klick untuk membuka Peta',
                        ),
                        SizedBox(height: 15.0),
                        TaskColumn(
                          widget: home(),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
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
                                /* onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => health(
                                            anak: viewModel.login.data!.anak),
                                      ),
                                    ),*/
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }
}

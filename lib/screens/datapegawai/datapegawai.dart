import 'package:absensi/data/remote/response/Status.dart';
import 'package:absensi/model/employee/EmployeeModel.dart';
import 'package:absensi/screens/datapegawai/detailpegawai.dart';
import 'package:absensi/screens/widget/MyErrorWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../theme/colors/light_colors.dart';
import '../../view_model/PegawaiVM.dart';
import '../../view_model/login/LoginVM.dart';
import '../login/login.dart';
import '../widget/LoadingWidget.dart';

class datapegawai extends StatefulWidget {
  final kodeunitkerja;

  const datapegawai({super.key, required this.kodeunitkerja});

  @override
  State<datapegawai> createState() => _datapegawai();
}

class _datapegawai extends State<datapegawai> {
  final LoginVM viewModel = LoginVM();
  final PegawaiVM viewpegawai = PegawaiVM();

  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      await viewpegawai.getdata(id.toString(), widget.kodeunitkerja);

      // print(viewpegawai.data.data!.data!.first.nama!);
      //print(viewModel.login.data!.data!.kodeUnitkerja!);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [IconButton(onPressed: (() {}), icon: Icon(Icons.search))],
          centerTitle: true,
          title: Text(
            "Data pegawai",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 42, 42, 42)),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: ChangeNotifierProvider<PegawaiVM>(
            create: (BuildContext context) => viewpegawai,
            child: Consumer<PegawaiVM>(builder: (context, viewpegawai, _) {
              switch (viewpegawai.data.status) {
                case Status.LOADING:
                  return LoadingWidget();
                case Status.ERROR:
                  return MyErrorWidget(viewpegawai.data.message ?? "NA");
                case Status.COMPLETED:
                  return _widgetbody(viewpegawai.data.data!.data!);
                default:
              }
              return Container();
            })));
  }

  Widget _widgetbody(List<Pegawai>? Listanak) {
    return ListView.builder(
        itemCount: Listanak?.length,
        itemBuilder: (context, position) {
          return _getAnakListItem(Listanak![position]);
        });
  }

  Widget _getAnakListItem(Pegawai item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detailpegawai(
              pegawai: item,
            ),
          ),
        );
      },
      child: Card(
          margin: EdgeInsets.only(top: 2),
          child: Container(
              height: 80,
              child: Ink(
                color: Colors.transparent,
                child: ListTile(
                  shape: Border.all(style: BorderStyle.none),
                  trailing: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Icon(Icons.calendar_month, color: Colors.amber),
                  ),
                  leading: SizedBox(
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                          "https://absensi.bengkaliskab.go.id/pegawai/" +
                              item.kodeUnitkerja! +
                              "/" +
                              item.image!),
                      backgroundColor: Colors.transparent,
                    ),
                    height: 80,
                    width: 50,
                  ),
                  title: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        ((item.gd! == "-") ? "" : item.gd!) +
                            item.nama! +
                            item.gb!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nip :" + item.nip!),
                      Text("NO HP :" + item.nohp!)
                    ],
                  ),
                ),
              ))),
    );
  }

  checkdata(data) {
    if (data != null) {
      //_widgetbody(data);
    }
  }
}

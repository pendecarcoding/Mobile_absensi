import 'dart:ui';

import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/DetailAbsenModel.dart';
import 'package:absensi/model/employee/EmployeeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';

import '../../data/remote/response/Status.dart';
import '../../theme/colors/light_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../view_model/absensi/AbsensiVM.dart';
import '../widget/LoadingWidget.dart';
import '../widget/MyErrorWidget.dart';

class detailpegawai extends StatefulWidget {
  @override
  final Pegawai pegawai;

  const detailpegawai({super.key, required this.pegawai});
  State<detailpegawai> createState() => _detailpegawai();
}

class _detailpegawai extends State<detailpegawai> {
  final AbsensiVM absensi = AbsensiVM();
  late final dynamic id;

  @override
  void initState() {
    super.initState();
    _getIdFromSession();
  }

  Future<void> _getIdFromSession() async {
    id = widget.pegawai.id;
    setState(() {
      Map<String, String> PostData = {
        "id": id.toString(),
        "kode_unitkerja": widget.pegawai.kodeUnitkerja.toString(),
        "jenis": selectedValue,
        "tgl": DateTime.now().toString().split(' ')[0],
      };

      getdata(PostData);
    });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Absen Masuk"), value: "M"),
      DropdownMenuItem(child: Text("Absen Pulang"), value: "P"),
    ];
    return menuItems;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  String selectedValue = "M";

  getdata(Map<String, String> data) async {
    try {
      await absensi.detailabsensi(data);
      print(data);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    void _confirmAndMakeCall(String phoneNumber) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Perhatian !!!'),
            content: Text(
                'Anda yakin akan memanggil Nomor : $phoneNumber , Tarif Operator mungkin akan berlaku sesuai dengan tarif masing masing operator'),
            actions: <Widget>[
              TextButton(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text('Panggil'),
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  String url = 'tel:$phoneNumber';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ],
          );
        },
      );
    }

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _confirmAndMakeCall(widget.pegawai.nohp!);
              },
              icon: Icon(Icons.call),
            ),
          ],
          centerTitle: false,
          title: Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0),
                  child: SizedBox(
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        "https://absensi.bengkaliskab.go.id/pegawai/" +
                            widget.pegawai.kodeUnitkerja! +
                            "/" +
                            widget.pegawai.image!,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    height: 45,
                    width: 50,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width *
                      0.5, // Adjust as needed
                  child: Text(
                    ((widget.pegawai.gd! == "-") ? "" : widget.pegawai.gd!) +
                        widget.pegawai.nama! +
                        widget.pegawai.gb!,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          backgroundColor: LightColors.primary,
        ),
        body: ListView(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 20),
              lastDay: DateTime.utc(2040, 10, 20),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  print(_selectedDay.toLocal().toString().split(' ')[0]);
                  Map<String, String> PostData = {
                    "id": id.toString(),
                    "kode_unitkerja": widget.pegawai.kodeUnitkerja.toString(),
                    "jenis": selectedValue,
                    "tgl": _selectedDay.toLocal().toString().split(' ')[0],
                  };

                  getdata(PostData);
                });
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                "STATUS KEHADIRAN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Pilih Jenis Absen Pegawai"),
              trailing: DropdownButton(
                value: selectedValue,
                items: dropdownItems,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    Map<String, String> PostData = {
                      "id": id.toString(),
                      "kode_unitkerja": widget.pegawai.kodeUnitkerja.toString(),
                      "jenis": selectedValue,
                      "tgl": _selectedDay.toLocal().toString().split(' ')[0],
                    };

                    getdata(PostData);
                  });
                },
              ),
            ),
            ChangeNotifierProvider<AbsensiVM>(
                create: (BuildContext context) => absensi,
                child: Consumer<AbsensiVM>(builder: (context, absensi, _) {
                  switch (absensi.absen.status) {
                    case Status.LOADING:
                      return LoadingWidget();
                    case Status.ERROR:
                      return MyErrorWidget(absensi.absen.message ?? "NA");
                    case Status.COMPLETED:
                      return _widgetbody(absensi.absen.data);
                    default:
                  }
                  return Container();
                })),
          ],
        ));
  }

  Widget _widgetbody([DetailAbsenModel? data]) {
    if (data != null) {
      return ListTile(
        title: Text("Kehadiran: ${data.status}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Latitude: ${data.latitude}"),
            Text("Longitude: ${data.longitude}"),
            Text("Waktu Absensi: ${data.waktuabsen}"),
            Text("Keterangan: ${data.keterangan}")
          ],
        ),
        trailing: Icon(
          Icons.map_outlined,
          color: Colors.orange,
        ),
      );
    } else {
      return Text("Belum melakukan absensi");
    }
  }
}

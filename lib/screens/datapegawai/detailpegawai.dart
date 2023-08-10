import 'dart:ui';

import 'package:absensi/model/employee/EmployeeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/colors/light_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class detailpegawai extends StatefulWidget {
  @override
  final Pegawai pegawai;

  const detailpegawai({super.key, required this.pegawai});
  State<detailpegawai> createState() => _detailpegawai();
}

class _detailpegawai extends State<detailpegawai> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Absen Masuk"), value: "masuk"),
      DropdownMenuItem(child: Text("Absen Pulang"), value: "pulang"),
    ];
    return menuItems;
  }

  String selectedValue = "masuk";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          actions: [IconButton(onPressed: (() {}), icon: Icon(Icons.call))],
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
                            widget.pegawai.image!),
                    backgroundColor: Colors.transparent,
                  ),
                  height: 45,
                  width: 50,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    ((widget.pegawai.gd! == "-") ? "" : widget.pegawai.gd!) +
                        widget.pegawai.nama! +
                        widget.pegawai.gb!,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: 2,
                  ))
            ],
          )),
          backgroundColor: LightColors.primary,
        ),
        body: ListView(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 20),
              lastDay: DateTime.utc(2040, 10, 20),
              focusedDay: DateTime.now(),
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
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Kehadiran : HADIR"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Latitude  :"),
                  Text("Longitude :"),
                  Text("Waktu Absensi : 08.00"),
                  Text(
                      "Keterangan : Telah melakukan Absensi di Lingkungan Kantor")
                ],
              ),
              trailing: Icon(
                Icons.map_outlined,
                color: Colors.orange,
              ),
            )
          ],
        ));
  }
}

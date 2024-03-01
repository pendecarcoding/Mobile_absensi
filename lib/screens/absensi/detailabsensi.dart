import 'dart:async';

import 'package:absensi/model/login/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/colors/light_colors.dart';
import '../widget/LoadingWidget.dart';
import 'luardinasambil.dart';

class detailabsensi extends StatefulWidget {
  final Listabsen listabsen;
  const detailabsensi(this.listabsen, {Key? key}) : super(key: key);

  @override
  State<detailabsensi> createState() => _detailabsensi();
}

class _detailabsensi extends State<detailabsensi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColors.primary,
        foregroundColor: Colors.white,
        title: Text("Detail Absensi"),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Card(
            child: ListTile(
          title: Text("Tanggal Absensi"),
          subtitle: Text(widget.listabsen.tglabsen!),
        )),
        SizedBox(
          height: 1,
        ),
        Card(
            child: ListTile(
          title: Text("Status"),
          subtitle: Text(widget.listabsen.status!),
        )),
        Card(
            child: ListTile(
          title: Text("Waktu Absensi"),
          subtitle: Text(widget.listabsen.time!),
        )),
        Card(
          color: Color.fromARGB(255, 47, 47, 47),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              padding: EdgeInsets.all(10),
              child: Stack(children: <Widget>[
                Center(
                  child: Image.network(
                    'https://absensi.bengkaliskab.go.id/public/swafoto/' +
                        widget.listabsen.kodeUnitkerja! +
                        '/' +
                        widget
                            .listabsen.swafoto!, // Replace with your image URL
                    loadingBuilder: (context, child, progress) {
                      return progress == null ? child : LoadingWidget();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error loading image');
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Lambang_Kabupaten_Bengkalis.png/381px-Lambang_Kabupaten_Bengkalis.png', // Replace with your image URL
                        loadingBuilder: (context, child, progress) {
                          return progress == null ? child : LoadingWidget();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Error loading image');
                        },
                      ),
                    ),
                    Text(
                      "Latitude : " + widget.listabsen.latitude!,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Longitude : " + widget.listabsen.longitude!,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ])),
        )
      ])),
    );
  }
}

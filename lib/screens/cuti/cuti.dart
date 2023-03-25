import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cuti extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  @override
  State<cuti> createState() => _cuti();
}

class _cuti extends State<cuti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengambilan Cuti"),
      ),
    );
  }
}

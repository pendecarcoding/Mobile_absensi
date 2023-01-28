import 'package:absensi/model/employee/EmployeeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/colors/light_colors.dart';

class datapegawai extends StatefulWidget {
  final pegawai;
  const datapegawai({Key? key, this.pegawai}) : super(key: key);

  @override
  State<datapegawai> createState() => _datapegawai();
}

class _datapegawai extends State<datapegawai> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitoring datapegawai"),
        backgroundColor: LightColors.Blue,
      ),
      body: _widgetbody(widget.pegawai),
    );
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
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detaildatapegawai(
                idkelas: item.idKelas!,
                idsekolah: item.idSekolahsiswa!,
                nis: item.nis),
          ),
        );*/
      },
      child: Card(
        margin: EdgeInsets.only(top: 2),
        child: ListTile(
          title: Text("Daftar Pegawai"),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Pegawai : " + item.nama!),
              Text("Nip :" + item.nip!),
              Text("NO HP :" + item.nohp!)
            ],
          ),
        ),
      ),
    );
  }
}

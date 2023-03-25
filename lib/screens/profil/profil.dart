import 'package:absensi/screens/widget/textfield_widget.dart';
import 'package:absensi/theme/colors/light_colors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/appbar_widget.dart';
import '../widget/profile_widget.dart';

class profil extends StatefulWidget {
  const profil({Key? key}) : super(key: key);

  @override
  State<profil> createState() => _profil();
  //Test
}

class _profil extends State<profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        elevation: 0,
        backgroundColor: LightColors.primary,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 180,
            child: Stack(children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: LightColors.primary),
                  )),
              Positioned(
                  top: 35,
                  left: 0,
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  child: ProfileWidget(
                    imagePath:
                        "https://absensi.bengkaliskab.go.id/pegawai/1603051001/638d97f86d964.png",
                    isEdit: true,
                    onClicked: () async {},
                  )),
            ]),
          ),
          Column(
            children: <Widget>[
              Text(
                "Bohati Mulyadi",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: LightColors.primary),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "Pengaturan Akun",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text("Pengaturan data akun"),
                  leading: Icon(
                    Icons.person,
                    color: LightColors.primary,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "Ubah Kata Sandi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text("ubah kata sandi anda disini"),
                  leading: Icon(
                    Icons.password,
                    color: LightColors.primary,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "Lokasi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text("Untuk pengaturan Lokasi"),
                  leading: Icon(
                    Icons.location_searching_outlined,
                    color: LightColors.primary,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "Pusat Bantuan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text("Pusat Bantuan Admin BKPP"),
                  leading: Icon(
                    Icons.help_sharp,
                    color: LightColors.primary,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:absensi/model/login/LoginModel.dart';
import 'package:absensi/screens/bantuan/bantuan.dart';
import 'package:absensi/screens/profil/editprofil.dart';
import 'package:absensi/screens/profil/ubahkatasandi.dart';
import 'package:absensi/screens/widget/textfield_widget.dart';
import 'package:absensi/theme/colors/light_colors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/appbar_widget.dart';
import '../widget/profile_widget.dart';
import 'package:location/location.dart';

class profil extends StatefulWidget {
  final Data data_peg;
  const profil(this.data_peg, {Key? key}) : super(key: key);

  @override
  State<profil> createState() => _profil();
  //Test
}

class _profil extends State<profil> {
  bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

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
                    imagePath: "https://absensi.bengkaliskab.go.id/pegawai/" +
                        widget.data_peg.kodeUnitkerja! +
                        "/" +
                        widget.data_peg.image!,
                    isEdit: true,
                    onClicked: () async {},
                  )),
            ]),
          ),
          Column(
            children: <Widget>[
              Text(
                widget.data_peg.nama.toString(),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: LightColors.primary),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => editprofil(widget.data_peg)),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      "Pengaturan Akun",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text("Pengaturan data akun"),
                    leading: Icon(
                      Icons.person,
                      color: LightColors.primary,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              Card(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ubahsandi(widget.data_peg)),
                  );
                },
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
              )),
              Card(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => bantuan()),
                  );
                },
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
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Enable Location'),
                trailing: Switch(
                  value: _serviceEnabled,
                  onChanged: (bool value) async {
                    setState(() {
                      _serviceEnabled = value;
                    });

                    if (value) {
                      _permissionGranted = await _location.requestPermission();
                      if (_permissionGranted == PermissionStatus.granted) {
                        _locationData = await _location.getLocation();
                      }
                    } else {
                      // _locationData = null;
                    }
                  },
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:absensi/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/colors/light_colors.dart';

class Nointernet extends StatelessWidget {
  Nointernet();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SvgPicture.asset(
              'assets/images/nointernet.svg',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Column(
              children: [
                Center(
                    child: Text(
                  "Internet Bermasalah",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                SizedBox(),
                Center(
                    child: Text(
                  "Pastikan koneksi internet anda stabil agar dapat menggunakan Layanan dari Aplikasi Absensi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 114, 114),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                  (Route<dynamic> route) => false,
                );
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                elevation: 30,
                textStyle: const TextStyle(color: Colors.white),
                backgroundColor: LightColors.primary,
              ),
              child: const Text('Coba Kembali'),
            ),
          )
        ],
      ),
    ));
  }
}

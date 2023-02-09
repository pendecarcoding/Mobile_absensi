import 'package:absensi/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nointernet extends StatelessWidget {
  Nointernet();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(66, 152, 170, 194),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 420,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/nointernet.png"))),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Center(
                    child: Text(
                  "Internet Bermasalah",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
                SizedBox(),
                Center(
                    child: Text(
                  "Pastikan koneksi internet anda stabil agar dapat menggunakan Layanan dari Aplikasi Absensi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 114, 114),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
                  elevation: 12.0,
                  textStyle: const TextStyle(color: Colors.white)),
              child: const Text('Coba Kembali'),
            ),
          )
        ],
      ),
    );
  }
}

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
        title: Text("Pengaturan Profil"),
        backgroundColor: LightColors.primary,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 30),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath:
                "https://absensi.bengkaliskab.go.id/pegawai/1603051001/638d97f86d964.png",
            isEdit: true,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Nama Lengkap',
            text: "Bohati Mulyadi",
            onChanged: (name) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: "bohatimulyadi99@gmail.com",
            onChanged: (email) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Alamat',
            text: "Jln Hangtuah",
            maxLines: 5,
            onChanged: (about) {},
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: LightColors.primary,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

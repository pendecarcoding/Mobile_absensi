import 'dart:convert';
import 'dart:io';

import 'package:absensi/model/login/LoginModel.dart';
import 'package:absensi/screens/widget/profile_widget_local.dart';
import 'package:absensi/screens/widget/textfield_widget.dart';
import 'package:absensi/theme/colors/light_colors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/remote/response/Status.dart';
import '../../view_model/login/LoginVM.dart';
import '../widget/appbar_widget.dart';
import '../widget/profile_widget.dart';

class editprofil extends StatefulWidget {
  final Data data_peg;
  const editprofil(this.data_peg, {Key? key}) : super(key: key);

  @override
  State<editprofil> createState() => _Eprofil(data_peg);
  //Test
}

class _Eprofil extends State<editprofil> {
  final Data data_peg;
  String? nama, email, alamat, id, nohp;
  final _key = new GlobalKey<FormState>();
  bool isLoading = false;
  File? _pickedImage;
  XFile? pickedImage_path;
  late String imagePath;
  File? _localImageFile;
  final LoginVM viewModel = LoginVM();
  _Eprofil(this.data_peg) {
    imagePath = "https://absensi.bengkaliskab.go.id/pegawai/" +
        data_peg.kodeUnitkerja! +
        "/" +
        data_peg.image!;
  }
  void handleClick() {
    setState(() {
      isLoading = true;
    });

    // Simulate an asynchronous operation
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 3, 155, 150),
            content: Text(viewModel.message.data!.message.toString()),
          ),
        );
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _localImageFile = File(pickedImage.path);
        pickedImage_path = pickedImage_path;
      });
    }
  }

  //checking form
  check() {
    /*Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => home()));
    */
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      handleClick();
      update();
    }
  }

  update() async {
    id = data_peg.idUser;

    Map<String, String> data = {
      'id': id!,
      'id_pegawai': data_peg.idPegawai!,
      'nama': nama!,
      'email': email!,
      'nohp': nohp!,
      'kode_unitkerja': data_peg.kodeUnitkerja!,
      'foto': (_localImageFile != null)
          ? imageToBase64(_localImageFile!)
          : 'kosong',
      'alamat': alamat!,
    };
    await viewModel.UpdateAccount(data)
        .then((value) => {if (viewModel.message.data!.message != null) {}});
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                color: Color.fromARGB(255, 154, 154, 154),
                Icons.info,
                size: 100,
              ),
              Text("Pilih Pengambilan Gambar"),
              SizedBox(height: 5),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 171, 88, 69),
                  ),
                  SizedBox(width: 1),
                  TextButton(
                    child: Text(
                      "Kamera",
                      style: TextStyle(color: LightColors.primary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ]),
                Row(children: [
                  Icon(
                    Icons.image,
                    color: Color.fromARGB(255, 171, 88, 69),
                  ),
                  SizedBox(width: 1),
                  TextButton(
                    child: Text(
                      "File Galeri",
                      style: TextStyle(color: LightColors.primary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  )
                ]),
              ],
            )
          ],
        );
      },
    );
  }

  String imageToBase64(imagePath) {
    final bytes = imagePath.readAsBytesSync();
    String img64 = base64Encode(bytes);
    return "data:image/jpeg;base64," + img64;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Pengaturan Profil"),
            backgroundColor: LightColors.primary,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            physics: BouncingScrollPhysics(),
            children: [
              if (_localImageFile == null)
                ProfileWidget(
                  imagePath: imagePath,
                  isEdit: true,
                  onClicked: () {
                    _showImagePickerDialog();
                  },
                ),
              if (_localImageFile != null)
                ProfileWidgetLocal(
                  imagePath: _localImageFile,
                  isEdit: true,
                  onClicked: () {
                    _showImagePickerDialog();
                  },
                ),
              const SizedBox(height: 24),
              TextFieldWidget(
                keyboardType: TextInputType.name,
                label: 'Nama Lengkap',
                text: widget.data_peg.nama!,
                onChanged: (name) {},
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Nama Tidak Boleh Kosong";
                  }
                },
                onSaved: (e) => nama = e,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                text: widget.data_peg.email!,
                onChanged: (email) {},
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Email Tidak Boleh Kosong";
                  }
                },
                onSaved: (e) => email = e,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                keyboardType: TextInputType.phone,
                label: 'NO HP',
                text: widget.data_peg.nohp!,
                onChanged: (nohp) {},
                validator: (e) {
                  if (e!.isEmpty) {
                    return "NO HP Tidak Boleh Kosong";
                  }
                },
                onSaved: (e) => nohp = e,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                keyboardType: TextInputType.streetAddress,
                label: 'Alamat',
                text: widget.data_peg.alamat!,
                maxLines: 2,
                onChanged: (about) {},
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Alamat Tidak Boleh Kosong";
                  }
                },
                onSaved: (e) => alamat = e,
              ),
              const SizedBox(height: 10),
              Container(
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: LightColors.primary,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Adjust the radius value to your preference
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white))
                          : SizedBox(),
                      if (!isLoading)
                        Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    check();
                  }, // Disable the button when loading
                ),
              )
            ],
          ),
        ));
  }
}

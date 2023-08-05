import 'package:absensi/screens/widget/passwordfield_widget.dart';
import 'package:absensi/screens/widget/textfield_widget.dart';
import 'package:absensi/theme/colors/light_colors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/login/LoginModel.dart';
import '../../view_model/login/LoginVM.dart';
import '../widget/appbar_widget.dart';
import '../widget/profile_widget.dart';

class ubahsandi extends StatefulWidget {
  final Data data_peg;
  const ubahsandi(this.data_peg, {Key? key}) : super(key: key);

  @override
  State<ubahsandi> createState() => _ubahsandi(data_peg);
  //Test
}

class _ubahsandi extends State<ubahsandi> {
  late final Data data_peg;
  final _key = new GlobalKey<FormState>();
  bool isLoading = false;
  String? oldpassword, password, confirpassword, id;
  final LoginVM viewModel = LoginVM();

  _ubahsandi(this.data_peg);
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
    id = data_peg.idUser!;

    Map<String, String> data = {
      'id': id!,
      'old_password': oldpassword!,
      'password': password!,
      'confirpassword': confirpassword!
    };
    await viewModel.UpdateSandi(data)
        .then((value) => {if (viewModel.message.data!.message != null) {}});
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
            backgroundColor: (viewModel.message.data!.message.toString() ==
                    'Data berhasil diupdate')
                ? Color.fromARGB(255, 3, 155, 150)
                : Color.fromARGB(255, 232, 15, 15),
            content: Text(viewModel.message.data!.message.toString()),
          ),
        );
      });
    });
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
              SizedBox(height: 24),
              PassFieldWidget(
                label: 'Password Lama',
                text: '',
                onChanged: (oldpassword) {},
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Password Lama tidak boleh kosong";
                  }
                },
                onSaved: (e) => oldpassword = e,
              ),
              const SizedBox(height: 24),
              PassFieldWidget(
                label: 'Password Baru',
                text: "",
                onChanged: (email) {},
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Field tidak boleh kosong";
                  }
                },
                onSaved: (e) => password = e,
              ),
              const SizedBox(height: 24),
              PassFieldWidget(
                label: 'Konfirmasi Password',
                text: "",
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Field boleh kosong";
                  }
                },
                onSaved: (e) => confirpassword = e,
                onChanged: (about) {},
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

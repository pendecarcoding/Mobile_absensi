import 'package:absensi/theme/colors/light_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../data/remote/response/Status.dart';
import '../../view_model/login/LoginVM.dart';
import '../home/home.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);
  @override
  State<login> createState() => _login();
}

enum LoginStatus { notSignIn, signIn }

class _login extends State<login> {
  bool? isChecked = false;
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? nip, password;
  final _key = new GlobalKey<FormState>();
  final LoginVM viewModel = LoginVM();
  check() {
    /*Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => home()));
    */
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    var data = await viewModel.actlogin(nip!, password!);
    switch (viewModel.login.status) {
      case Status.ERROR:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Username dan password salah'),
          ),
        );
        break;
      case Status.COMPLETED:
        try {
          if (viewModel.login.data!.data! == null) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: const Text('Username dan password salah'),
            //   ),
            // );
            print("SALAH PASSWORD");
          } else {
            viewModel.login.data!.data!.idUser;
            savepref(viewModel.login.data!.data!.idUser);
          }
        } catch (_) {
          // <-- removing the on Exception clause
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Akun tidak tersedia'),
            ),
          );
          throw Exception("Error on server");
        }

        break;
      default:
        break;
    }
  }

  savepref(String? id) async {
    await SessionManager().set("id", id).then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => home())));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key: _key,
        child: Scaffold(
            body: Container(
          color: LightColors.primary,
          width: double.infinity,
          height: double.infinity,
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Color.fromARGB(255, 246, 246, 246),
          //       Color.fromARGB(255, 255, 255, 255),
          //       Color.fromARGB(255, 255, 255, 255),
          //       Color.fromARGB(255, 255, 255, 255),
          //     ],
          //   ),
          // ),
          child: SingleChildScrollView(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 60),
            child: Column(
              children: [
                // const Text(
                //   'ABSENSIKU',
                //   style: TextStyle(
                //       fontFamily: 'PT-Sans',
                //       fontSize: 30,
                //       fontWeight: FontWeight.bold,
                //       color: Color.fromARGB(255, 255, 255, 255)),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/absen-removebg-preview.png",
                  width: 300,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'NIP ',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField(
                  hintText: 'NIP Pegawai',
                  obscureText: false,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "NIP harus diisi";
                    }
                  },
                  onSaved: (e) => nip = e,
                  prefixedIcon: const Icon(Icons.mail,
                      color: Color.fromARGB(255, 240, 181, 19)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField(
                  hintText: 'Enter your password',
                  obscureText: true,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Password harus diisi";
                    }
                  },
                  onSaved: (e) => password = e,
                  prefixedIcon: const Icon(Icons.lock,
                      color: Color.fromARGB(255, 240, 181, 19)),
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildForgotPasswordButton(),
                // _buildRemeberMe(),
                const SizedBox(
                  height: 15,
                ),
                _buildLoginButton(onPressed: () {
                  check();
                }),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
        )));
  }

  Widget _buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text(
          'Lupa Password?',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 14,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        onPressed: () {
          _dialoglupa(context);
        },
      ),
    );
  }

  Future<void> _dialoglupa(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PERHATIAN !!!'),
          content: const Text(
              'Untuk Melakukan Reset Password silahkan hubungi Operator SKPD anda'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Widget _buildRemeberMe() {
  //   return Row(
  //     children: [
  //       Checkbox(
  //         value: isChecked,
  //         onChanged: (value) {
  //           setState(() {
  //             isChecked = value;
  //           });
  //         },
  //         checkColor: Color.fromARGB(255, 56, 137, 203),
  //         fillColor:
  //             MaterialStateProperty.all(Color.fromARGB(255, 255, 255, 255)),
  //       ),
  //       const Text(
  //         'Remember me',
  //         style: TextStyle(
  //           fontFamily: 'PT-Sans',
  //           fontSize: 14,
  //           color: Color.fromARGB(255, 255, 255, 255),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLoginButton({required VoidCallback onPressed}) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color.fromARGB(255, 240, 181, 19),
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildTextField({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    required String? Function(dynamic e) validator,
    required Function(dynamic e) onSaved,
  }) {
    return Material(
      color: Color.fromARGB(0, 34, 33, 33),
      elevation: 2,
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 36, 36, 36),
        cursorWidth: 2,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        style: const TextStyle(color: Color.fromARGB(255, 24, 24, 24)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 251, 251, 251),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 30, 30, 30),
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  //check class
}

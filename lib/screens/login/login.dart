import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 246, 246, 246),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
      ),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 60),
        child: Column(
          children: [
            const Text(
              'E-Absensi',
              style: TextStyle(
                  fontFamily: 'PT-Sans',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 75, 75, 75)),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/slider_1.png",
              width: 190,
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
                  color: Color.fromARGB(255, 151, 150, 150),
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
              prefixedIcon: const Icon(Icons.mail, color: Colors.white),
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
                  color: Color.fromARGB(255, 75, 75, 75),
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
              prefixedIcon: const Icon(Icons.lock, color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            _buildForgotPasswordButton(),
            _buildRemeberMe(),
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
    ));
  }

  Widget _buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 14,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildRemeberMe() {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value;
            });
          },
          checkColor: Color.fromARGB(255, 56, 137, 203),
          fillColor: MaterialStateProperty.all(Color.fromARGB(255, 75, 75, 75)),
        ),
        const Text(
          'Remember me',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 14,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton({required VoidCallback onPressed}) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color.fromARGB(255, 9, 164, 64),
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
      color: Colors.transparent,
      elevation: 2,
      child: TextFormField(
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 106, 106, 106),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  //check class
  check() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => home()));
  }
}
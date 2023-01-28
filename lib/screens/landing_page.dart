import 'package:absensi/screens/home/home.dart';
import 'package:absensi/view_model/login/LoginVM.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../ui_view/slider_layout_view.dart';
import 'login/login.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final LoginVM viewModel = LoginVM();
  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => home()));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      );
}

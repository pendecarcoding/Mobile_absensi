import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/colors/light_colors.dart';

class ekinerja extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  @override
  State<ekinerja> createState() => _ekinerja();
}

class _ekinerja extends State<ekinerja> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-KINERJA"),
        foregroundColor: Colors.white,
        backgroundColor: LightColors.primary,
      ),
      body: WebView(
        initialUrl: 'https://kinerja.bkn.go.id/login',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

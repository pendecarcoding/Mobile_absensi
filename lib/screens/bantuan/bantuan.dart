import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/colors/light_colors.dart';

class bantuan extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  @override
  State<bantuan> createState() => _bantuan();
}

class _bantuan extends State<bantuan> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Layanan"),
        foregroundColor: Colors.white,
        backgroundColor: LightColors.primary,
      ),
      body: WebView(
        initialUrl: 'https://tawk.to/chat/64d37791cc26a871b02e37f5/1h7d0m4uu',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

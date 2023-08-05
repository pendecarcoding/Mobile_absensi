import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/colors/light_colors.dart';

class viewSurat extends StatefulWidget {
  final link;
  const viewSurat({super.key, required this.link});
  @override
  _ViewSuratState createState() => _ViewSuratState();
}

class _ViewSuratState extends State<viewSurat> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surat Pengajuan"),
        backgroundColor: LightColors.primary,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://docs.google.com/gview?embedded=true&url=' +
                widget.link.toString(), // Replace with the URL you want to load
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (_) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
        // Enable JavaScript support
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../theme/colors/light_colors.dart';

class viewSuratdinas extends StatefulWidget {
  final link;
  const viewSuratdinas({super.key, required this.link});
  @override
  _ViewSuratState createState() => _ViewSuratState();
}

class _ViewSuratState extends State<viewSuratdinas> {
  late File Pfile;
  bool isLoading = false;
  Future<void> openPDF(String pdfFilePath) async {
    final result = await OpenFile.open(pdfFilePath);
    if (result.type == ResultType.done) {
      print('Opened successfully: ${result.message}');
    } else {
      print('Error opening file: ${result.message}');
    }
  }

  Future<void> downloadPDF(String pdfUrl, String pdfFilePath) async {
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      final urlSegments = pdfUrl.split('/');
      final pdfFileName = urlSegments.last; // Extract the filename from the URL

      final directory = await getExternalStorageDirectory();
      final filePath = pdfFilePath;

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('PDF downloaded to: $filePath');
    } else {
      throw Exception('Failed to download PDF');
    }
  }

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.link;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              final pdfUrl = widget.link;
              final pdfFileName = pdfUrl.split('/').last;

              final directory = await getExternalStorageDirectory();
              final pdfFilePath = '${directory!.path}/$pdfFileName';
              await downloadPDF(pdfUrl, pdfFilePath);
              openPDF(pdfFilePath); // Open the downloaded PDF
            },
          ),
        ],
        backgroundColor: LightColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          "SURAT PERINTAH TUGAS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child: PDFView(
                  filePath: Pfile.path,
                ),
              ),
            ),
    );
  }
}

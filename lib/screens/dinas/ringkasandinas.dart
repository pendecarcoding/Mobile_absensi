import 'dart:io';

import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:absensi/screens/cuti/viewsurat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../theme/colors/light_colors.dart';
import '../../view_model/absensi/CutiVM.dart';
import '../widget/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ringkasandinas extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  final id_pegawai;
  final Cuti data_cuti;
  const ringkasandinas(
      {super.key, required this.id_pegawai, required this.data_cuti});
  @override
  State<ringkasandinas> createState() => _ringkasandinas();
}

class _ringkasandinas extends State<ringkasandinas> {
  String? selectedOption;
  String? jeniscuti, dari, sampai, alasan;
  final CutiVM viewModel = CutiVM();
  DateTime? fromDate;
  bool isLoading = false;
  DateTime? toDate;
  String? filePath;
  final _key = new GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController dateendController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  late String rangecuti;
  Future<void> _downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      // Show a SnackBar or any other notification that the download is complete
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded successfully!')),
      );
    } else {
      // Handle the error when the download fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File download failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String tipecuti, awalcuti, batascuti;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final fromDateText = DateFormat('yyyy-MM-dd');
    final toDateText = toDate != null ? dateFormat.format(toDate!) : '';
    return Form(
        key: _key,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Form Edit Cuti"),
            backgroundColor: LightColors.primary,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      "Jenis Cuti :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text(widget.data_cuti.jenisCuti!),
                    leading: Icon(
                      Icons.file_copy,
                      color: LightColors.primary,
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      "Rentang Cuti :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text(widget.data_cuti.rentangAbsen!),
                    leading: Icon(
                      Icons.file_copy,
                      color: LightColors.primary,
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      "Alasan Cuti :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text(widget.data_cuti.alasan!),
                    leading: Icon(
                      Icons.file_copy,
                      color: LightColors.primary,
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    // Call the download function when the card is tapped
                    _downloadFile(
                        'https://absensi.bengkaliskab.go.id/uploads/' +
                            widget.data_cuti.file!,
                        'downloaded_file.pdf');
                  },
                  child: ListTile(
                    title: Text(
                      "File :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text(widget.data_cuti.file!),
                    leading: Icon(
                      Icons.file_copy,
                      color: LightColors.primary,
                    ),
                    trailing: Icon(Icons.download),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      "Status Izin :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text(
                        (widget.data_cuti.status!.toString() == 'A')
                            ? "Tahap Verifikasi"
                            : (widget.data_cuti.status!.toString() == 'Y')
                                ? "Disetujui"
                                : "Ditolak",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Icons.file_copy,
                      color: LightColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

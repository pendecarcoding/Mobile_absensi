import 'dart:io';

import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:absensi/screens/cuti/viewsurat.dart';
import 'package:absensi/screens/dinas/viewsuratdinas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../model/absensi/DinasModel.dart';
import '../../theme/colors/light_colors.dart';
import '../../view_model/absensi/CutiVM.dart';
import '../widget/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class editdinas extends StatefulWidget {
  final id_pegawai;
  final Dinas data_dinas;
  const editdinas(
      {super.key, required this.id_pegawai, required this.data_dinas});
  @override
  State<editdinas> createState() => _editdinas();
}

class _editdinas extends State<editdinas> {
  String? selectedOption;
  String? jeniscuti, dari, sampai, alasan, nospt;
  final CutiVM viewModel = CutiVM();
  DateTime? fromDate;
  bool isLoading = false;
  DateTime? toDate;
  String? filePath;
  final _key = new GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController dateendController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textSPT = TextEditingController();
  late String rangecuti;

  @override
  void initState() {
    _textEditingController.text = widget.data_dinas.alasan!;
    _textSPT.text = widget.data_dinas.nospt!;
    rangecuti = widget.data_dinas.rentangAbsen!;
    final List<String> parts = explodeString(rangecuti, ' s/d ');
    final String part0 = getExplodedPart(parts, 0);
    final String part1 = getExplodedPart(parts, 1);
    dateController.text = part0; //set the initial value of text field
    dateendController.text = part1;
    super.initState();
  }

  String getExplodedPart(List<String> parts, int index) {
    if (index >= 0 && index < parts.length) {
      return parts[index];
    }
    return '';
  }

  List<String> explodeString(String str, String delimiter) {
    return str.split(delimiter);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void handleClick() {
    setState(() {
      isLoading = true;
    });

    // Simulate an asynchronous operation
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                (viewModel.datacuti.data!.message! == 'Update Berhasil')
                    ? Color.fromARGB(255, 3, 155, 150)
                    : Color.fromARGB(255, 232, 15, 15),
            content: Text(viewModel.datacuti.data!.message!.toString()),
          ),
        );
      });
    });
  }

  check() {
    /*Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => home()));
    */
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      addactcuti();
    }
  }

  addactcuti() async {
    dynamic id = widget.data_dinas.idPegawai;
    if (id != null) {
      Map<String, String> data = {
        'id': id.toString(),
        'id_dinas': widget.data_dinas.id.toString(),
        'nospt': nospt!,
        'dari': dari!,
        'sampai': sampai!,
        'alasan': alasan!,
      };
      if (filePath != null) {
        handleClick();
        File pdfFile = File(filePath!);
        await viewModel.updatedinasimage(pdfFile, data);
      } else {
        handleClick();
        await viewModel.updatedinasnoimage(data);
      }
    }
  }

  Future<void> pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          filePath = result.files.single.path!;
        });
      }
    } catch (e) {
      // Handle error...
    }
  }

  Future _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          dateController.text = formattedDate;
        } else {
          toDate = pickedDate;
          String formattedDateend = DateFormat('yyyy-MM-dd').format(pickedDate);
          dateendController.text = formattedDateend;
        }
      });
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
            title: Text("Form Edit Dinas"),
            backgroundColor: LightColors.primary,
            foregroundColor: Colors.white,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: TextFormField(
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Field ini tidak boleh kosong";
                          }
                        },
                        onSaved: (e) => dari = e,
                        controller:
                            dateController, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Dari" //label text of field
                            ),
                        readOnly: true, // when true user cannot edit text
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      child: TextFormField(
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Field ini tidak boleh kosong";
                          }
                        },
                        onSaved: (e) => sampai = e,
                        controller:
                            dateendController, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Sampai" //label text of field
                            ),
                        readOnly: true,
                        onTap: () => _selectDate(
                            context, false), // when true user cannot edit text
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: pickPDFFile,
                child: Container(
                  width: 200, // Set the desired width for the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.attach_file,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          filePath ?? 'Tap untuk pilih file PDF',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  final String link =
                      'https://absensi.bengkaliskab.go.id/uploads/dinas/' +
                          widget.data_dinas.file!.toString();
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          viewSuratdinas(link: link),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Berkas SPT Sebelumnya: ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: widget.data_dinas.file!,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _textSPT,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Field ini tidak boleh kosong";
                  }
                },
                onSaved: (e) => nospt = e,
                decoration: InputDecoration(
                  labelText: 'NO SPT',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Field ini tidak boleh kosong";
                  }
                },
                onSaved: (e) => alasan = e,
                decoration: InputDecoration(
                  labelText: 'Keterangan Dinas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
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
                          'Update Dinas',
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
              ),
            ],
          ),
        ));
  }
}

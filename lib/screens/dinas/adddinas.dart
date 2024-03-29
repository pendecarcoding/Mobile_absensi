import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../theme/colors/light_colors.dart';
import '../../view_model/absensi/CutiVM.dart';
import '../widget/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class adddinas extends StatefulWidget {
  /*final kantor;
  final pegawai;

  const ambilabsen({super.key, required this.kantor, required this.pegawai});
  */
  final id_pegawai;
  const adddinas({super.key, required this.id_pegawai});
  @override
  State<adddinas> createState() => _adddinas();
}

class _adddinas extends State<adddinas> {
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

  @override
  void initState() {
    dateController.text = ""; //set the initial value of text field
    dateendController.text = ""; //set the initial value of text field
    super.initState();
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
            backgroundColor: (viewModel.datacuti.data!.message! ==
                    'File uploaded successfully')
                ? Color.fromARGB(255, 3, 155, 150)
                : Color.fromARGB(255, 232, 15, 15),
            content: Text(viewModel.datacuti.data!.message!.toString()),
          ),
        );
        if (viewModel.datacuti.data!.message! == 'File uploaded successfully') {
          Navigator.pop(context, true);
        }
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
      handleClick();
      addactcuti();
    }
  }

  addactcuti() async {
    dynamic id = widget.id_pegawai;
    if (id != null) {
      Map<String, String> data = {
        'id': id.toString(),
        'dari': dari!,
        'sampai': sampai!,
        'alasan': alasan!,
        'nospt': nospt!,
      };
      if (filePath!.isNotEmpty) {
        File pdfFile = File(filePath!);
        await viewModel.adddatadinas(pdfFile, data);
      }
    } else {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => login()));
    }
  }

Future<void> pickPDFFile() async {
  // Check if permission is granted
  await Permission.storage.status;
  var status = await Permission.storage.status;
  if (status.isGranted) {
    // Permission is already granted, proceed with file picking
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
        print(e);
    }
  } else if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    // Permission is denied or restricted, request permission
    var requestStatus = await Permission.storage.request();
    if (requestStatus.isGranted) {
      // Permission granted, proceed with file picking
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
        print(e);
      }
    } else {
      // Permission denied, show a message or handle it accordingly
      // For example, you can show a SnackBar or AlertDialog informing the user
      // that the permission is required to pick a PDF file.
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Permission denied to pick PDF file.'),
      // ));
      // Or show an AlertDialog
      await Permission.storage.status;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Permission is required to pick PDF files.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
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
            title: Text("Form Pengajuan Dinas"),
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
              TextFormField(
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
                          'Upload Dinas',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    if (filePath != null) {
                      // Perform the action when a file is chosen
                      // For example, you can call a function or navigate to another screen
                      // Your existing function: pickPDFFile();
                      check();
                    } else {
                      // Show a snackbar to inform the user to choose a file
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mohon untuk menyertakan file PDF'),
                        ),
                      );
                    }
                  }, // Disable the button when loading
                ),
              ),
            ],
          ),
        ));
  }
}

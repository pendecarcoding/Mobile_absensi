import 'package:absensi/model/login/LoginModel.dart';
import 'package:absensi/screens/cuti/addcuti.dart';
import 'package:absensi/screens/cuti/ringkasan.dart';
import 'package:absensi/view_model/absensi/AbsensiVM.dart';
import 'package:absensi/view_model/absensi/CutiVM.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';

import '../../data/remote/response/Status.dart';
import '../../model/absensi/CutiModel.dart';
import '../../theme/colors/light_colors.dart';
import '../login/login.dart';
import '../widget/LoadingWidget.dart';
import '../widget/MyErrorWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'editcuti.dart';

class cuti extends StatefulWidget {
  final kodeunitkerja;
  final id_pegawai;

  const cuti(
      {super.key, required this.kodeunitkerja, required this.id_pegawai});
  @override
  State<cuti> createState() => _cuti();
}

class _cuti extends State<cuti> {
  final CutiVM viewCuti = CutiVM();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This method will be called when dependencies change, including when navigating back to this widget.
    getdata();
    // super.initState();
  }

  @override
  void initState() {
    super.initState();
  }

  getdata() async {
    dynamic id = widget.id_pegawai;
    if (id != null) {
      await viewCuti.getdatacuti(id, widget.kodeunitkerja);
      // print(viewCuti.data.status);
      // print(widget.kodeunitkerja);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Cuti"),
        backgroundColor: LightColors.primary,
      ),
      body: ChangeNotifierProvider<CutiVM>(
          create: (BuildContext context) => viewCuti,
          child: Consumer<CutiVM>(builder: (context, viewCuti, _) {
            switch (viewCuti.data.status) {
              case Status.LOADING:
                return LoadingWidget();
              case Status.ERROR:
                return MyErrorWidget(viewCuti.data.message ?? "NA");
              case Status.COMPLETED:
                return _widgetbody(viewCuti.data.data!.data!);
              default:
            }
            return Container();
          })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColors.primary,
        onPressed: () async {
          // Navigate to the addcuti activity and wait for the result
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  addcuti(id_pegawai: widget.id_pegawai),
            ),
          );

          // After returning from addcuti, check if data was updated and refresh the data
          if (result == true) {
            await getdata();
          } else {
            await getdata();
          }
        },
        child: const Icon(Icons.file_open),
      ),
    );
  }

  Widget _widgetbody(List<Cuti>? Listcuti) {
    if (Listcuti!.length > 0) {
      return ListView.builder(
          itemCount: Listcuti?.length,
          itemBuilder: (context, position) {
            return _getCutiListItem(Listcuti![position]);
          });
    } else {
      return datakosong();
    }
  }

  Widget _getCutiListItem(Cuti item) {
    return GestureDetector(
        onTap: () {},
        child: Card(
          child: Container(
              child: Ink(
                  color: Colors.transparent,
                  child: ListTile(
                    shape: Border.all(style: BorderStyle.none),
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        if (item.status!.toString() == 'Y') {
                          // If status is 'Tahap Verifikasi', hide the items
                          return [
                            PopupMenuItem(
                              child: Text('Ringkasan'),
                              value: 'ringkasan',
                            ),
                          ];
                        } else {
                          return [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                            PopupMenuItem(
                              child: Text('Batal Pengajuan'),
                              value: 'batal',
                            ),
                          ];
                        }
                      },
                      onSelected: (value) async {
                        if (value == 'edit') {
                          // Handle edit action
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => editcuti(
                                      id_pegawai: widget.id_pegawai,
                                      data_cuti: item)));
                          if (result == true) {
                            await getdata();
                          } else {
                            await getdata();
                          }
                        } else if (value == 'ringkasan') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ringkasan(
                                      id_pegawai: widget.id_pegawai,
                                      data_cuti: item)));
                        } else if (value == 'delete') {
                          // Handle delete action
                          // print('Delete: ' + item.id.toString());
                          deleteAlert(
                              context, item.id.toString(), viewCuti, item);
                        } else if (value == 'batal') {
                          // Handle delete action
                          batalkanAlert(
                              context, item.id.toString(), viewCuti, item);
                        }
                      },
                      child: Icon(Icons.more_vert,
                          color: Color.fromARGB(255, 99, 99, 99)),
                    ),
                    title: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        item.alasan.toString(),
                        style: TextStyle(
                            color: LightColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jenis Cuti :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(item.jenisCuti!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              "Rentang Cuti :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                                child: Row(
                              children: [Text(item.rentangAbsen.toString())],
                            )),
                            Text(
                              "Status :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                                (item.status!.toString() == 'A')
                                    ? "Tahap Verifikasi"
                                    : (item.status.toString() == 'Y')
                                        ? "Disetujui"
                                        : "Ditolak",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ]),
                    ),
                  ))),
        ));
  }

  Widget datakosong() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Container(
              width: 200,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                'assets/images/nodata.svg',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Data tidak tersedia",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10), // Add desired spacing
                  Center(
                    child: Text(
                      "Opps... untuk saat ini anda belum mengajukan cuti untuk mengajukan cuti anda dapat menekan tombol di bawah pojok kanan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 114, 114),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> deleteAlert(BuildContext context, id, CutiVM viewCuti, Cuti item) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Apakah anda yakin akan menghapus data ini ?'),
        content: const Text('data yang dihapus tidak dapat dikembalikan lagi'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Tidak'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Ya'),
            onPressed: () async {
              await viewCuti.deletecuti(id).then((value) async {
                await viewCuti.getdatacuti(
                    item.idPegawai.toString(), item.idInstansi.toString());
                Navigator.pop(context, true);
              });
            },
          ),
        ],
      );
    },
  );
}

Future<void> batalkanAlert(
    BuildContext context, id, CutiVM viewCuti, Cuti item) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Apakah anda yakin akan membatalkan Cuti ini ?'),
        content: const Text(
            'Status pengajuan akan di batalkan dan data tidak akan tampil di list pengajuan'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Tidak'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Ya'),
            onPressed: () async {
              await viewCuti.deletecuti(id).then((value) async {
                await viewCuti.getdatacuti(
                    item.idPegawai.toString(), item.idInstansi.toString());
                Navigator.pop(context, true);
              });
            },
          ),
        ],
      );
    },
  );
}

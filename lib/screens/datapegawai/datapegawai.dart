import 'package:absensi/data/remote/response/Status.dart';
import 'package:absensi/model/employee/EmployeeModel.dart';
import 'package:absensi/screens/datapegawai/detailpegawai.dart';
import 'package:absensi/screens/widget/MyErrorWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../theme/colors/light_colors.dart';
import '../../view_model/PegawaiVM.dart';
import '../../view_model/login/LoginVM.dart';
import '../login/login.dart';
import '../widget/LoadingWidget.dart';

class datapegawai extends StatefulWidget {
  final kodeunitkerja;

  const datapegawai({super.key, required this.kodeunitkerja});

  @override
  State<datapegawai> createState() => _datapegawai();
}

class _datapegawai extends State<datapegawai> {
  final PegawaiVM viewpegawai = PegawaiVM();
  bool _isSearchVisible = false; // Keep track of search visibility
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode(); // FocusNode for search input
  List<Pegawai>? originalList;
  List<Pegawai>? Listpegawai;
  @override
  void initState() {
    String query = '';
    getdata(query);
    super.initState();
  }

  getdata(query) async {
    dynamic id = await SessionManager().get("id");
    if (id != null) {
      await viewpegawai.getdata(id.toString(), widget.kodeunitkerja, query);

      // print(viewpegawai.data.data!.data!.first.nama!);
      //print(viewModel.login.data!.data!.kodeUnitkerja!);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => login()));
    }
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocus.requestFocus(); // Focus the search input
      } else {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        actions: [
          IconButton(
            onPressed: _toggleSearchVisibility,
            icon: _isSearchVisible
                ? Icon(Icons.close) // Change to close icon
                : Icon(Icons.search), // Default search icon
          ),
        ],
        centerTitle: true,
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocus, // Assign the focus node
                style: TextStyle(color: Colors.white),
                onChanged: (query) {
                  search(query); // Call your search function here
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              )
            : Text(
                "Data pegawai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
        backgroundColor: LightColors.primary,
      ),
      body: ChangeNotifierProvider<PegawaiVM>(
        create: (BuildContext context) => viewpegawai,
        child: Consumer<PegawaiVM>(
          builder: (context, viewpegawai, _) {
            switch (viewpegawai.data.status) {
              case Status.LOADING:
                return LoadingWidget();
              case Status.ERROR:
                return MyErrorWidget(viewpegawai.data.message ?? "NA");
              case Status.COMPLETED:
                
                if(viewpegawai.data.data!.data!.isNotEmpty){
                    Listpegawai = viewpegawai.data.data!.data!;
                    return _widgetbody(Listpegawai);
                }else{
                    return Center(
                      child: Text("Data tidak di temukan"),
                    );
                }

                

              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Future<void> search(String query) async {
    await getdata(query);
    print(query);
  }

  Widget _widgetbody(Listpegawai) {
    return ListView.builder(
        itemCount: Listpegawai?.length,
        itemBuilder: (context, position) {
          return _getAnakListItem(Listpegawai![position]);
        });
  }

  Widget _getAnakListItem(Pegawai item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detailpegawai(
              pegawai: item,
            ),
          ),
        );
      },
      child: Card(
          margin: EdgeInsets.only(top: 2),
          child: Container(
              child: Ink(
                color: Colors.transparent,
                child: ListTile(
                  shape: Border.all(style: BorderStyle.none),
                  trailing: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Icon(Icons.calendar_month, color: Colors.amber),
                  ),
                  leading: SizedBox(
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                          "https://absensi.bengkaliskab.go.id/pegawai/" +
                              item.kodeUnitkerja! +
                              "/" +
                              item.image!),
                      backgroundColor: Colors.transparent,
                    ),
                    height: 80,
                    width: 50,
                  ),
                  title: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        ((item.gd! == "-") ? "" : item.gd!) +
                            item.nama! +' '+
                            item.gb!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nip :" + item.nip!),
                      Text("NO HP :" + item.nohp!)
                    ],
                  ),
                ),
              ))),
    );
  }

  checkdata(data) {
    if (data != null) {
      //_widgetbody(data);
    }
  }
}

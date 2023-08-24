import 'dart:io';

import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:absensi/model/employee/EmployeeModel.dart';

import '../../model/absensi/DinasModel.dart';
import '../../model/message/ResponseModel.dart';

class CutiRepo {
  Future<CutiModel?> getcuti(String id, String id_instansi) async {}
  Future<DinasModel?> getdinas(String id, String id_instansi) async {}
  Future<ResponseModel?> addcuti(
      File file, Map<String, dynamic> requestData) async {}
  Future<ResponseModel?> adddinas(
      File file, Map<String, dynamic> requestData) async {}

  Future<ResponseModel?> updatedinasnoimage(
      Map<String, dynamic> requestData) async {}
  Future<ResponseModel?> updatedinasuseimage(
      File file, Map<String, dynamic> requestData) async {}

  Future<ResponseModel?> deletecuti(String id) async {}
  Future<ResponseModel?> deletedinas(String id) async {}
  Future<ResponseModel?> updatecutinoimage(
      Map<String, dynamic> requestData) async {}
  Future<ResponseModel?> updatecutiuseimage(
      File file, Map<String, dynamic> requestData) async {}
}

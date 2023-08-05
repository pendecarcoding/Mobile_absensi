class CutiModel {
  String? message;
  List<Cuti>? data;

  CutiModel({this.message, this.data});

  CutiModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Cuti>[];
      json['data'].forEach((v) {
        data!.add(new Cuti.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cuti {
  int? id;
  String? jenisCuti;
  String? idPegawai;
  String? idInstansi;
  String? file;
  String? rentangAbsen;
  String? alasan;
  String? status;
  String? createdAt;
  String? updatedAt;

  Cuti(
      {this.id,
      this.jenisCuti,
      this.idPegawai,
      this.idInstansi,
      this.file,
      this.rentangAbsen,
      this.alasan,
      this.status,
      this.createdAt,
      this.updatedAt});

  Cuti.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jenisCuti = json['jenis_cuti'];
    idPegawai = json['id_pegawai'];
    idInstansi = json['id_instansi'];
    file = json['file'];
    rentangAbsen = json['rentang_absen'];
    alasan = json['alasan'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jenis_cuti'] = this.jenisCuti;
    data['id_pegawai'] = this.idPegawai;
    data['id_instansi'] = this.idInstansi;
    data['file'] = this.file;
    data['rentang_absen'] = this.rentangAbsen;
    data['alasan'] = this.alasan;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

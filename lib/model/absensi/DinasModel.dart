class DinasModel {
  String? message;
  List<Dinas>? data;

  DinasModel({this.message, this.data});

  DinasModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Dinas>[];
      json['data'].forEach((v) {
        data!.add(new Dinas.fromJson(v));
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

class Dinas {
  int? id;
  String? idPegawai;
  String? idInstansi;
  String? file;
  String? rentangAbsen;
  String? nospt;
  String? alasan;
  String? status;
  String? createdAt;
  String? updatedAt;

  Dinas(
      {this.id,
      this.idPegawai,
      this.idInstansi,
      this.file,
      this.rentangAbsen,
      this.nospt,
      this.alasan,
      this.status,
      this.createdAt,
      this.updatedAt});

  Dinas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idPegawai = json['id_pegawai'];
    idInstansi = json['id_instansi'];
    file = json['file'];
    rentangAbsen = json['rentang_absen'];
    nospt = json['nospt'];
    alasan = json['alasan'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_pegawai'] = this.idPegawai;
    data['id_instansi'] = this.idInstansi;
    data['file'] = this.file;
    data['rentang_absen'] = this.rentangAbsen;
    data['nospt'] = this.nospt;
    data['alasan'] = this.alasan;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

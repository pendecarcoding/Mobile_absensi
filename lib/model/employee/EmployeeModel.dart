class EmployeeModel {
  String? message;
  List<Pegawai>? data;

  EmployeeModel({this.message, this.data});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Pegawai>[];
      json['data'].forEach((v) {
        data!.add(new Pegawai.fromJson(v));
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

class Pegawai {
  int? id;
  String? nip;
  String? nama;
  String? email;
  String? gd;
  String? gb;
  String? nohp;
  String? image;
  String? status;
  String? kodeUnitkerja;
  String? createdAt;
  String? updatedAt;

  Pegawai(
      {this.id,
      this.nip,
      this.nama,
      this.email,
      this.gd,
      this.gb,
      this.nohp,
      this.image,
      this.status,
      this.kodeUnitkerja,
      this.createdAt,
      this.updatedAt});

  Pegawai.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nip = json['nip'];
    nama = json['nama'];
    email = json['email'];
    gd = json['gd'];
    gb = json['gb'];
    nohp = json['nohp'];
    image = json['image'];
    status = json['status'];
    kodeUnitkerja = json['kode_unitkerja'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nip'] = this.nip;
    data['nama'] = this.nama;
    data['email'] = this.email;
    data['gd'] = this.gd;
    data['gb'] = this.gb;
    data['nohp'] = this.nohp;
    data['image'] = this.image;
    data['status'] = this.status;
    data['kode_unitkerja'] = this.kodeUnitkerja;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

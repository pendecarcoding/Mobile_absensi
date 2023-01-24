class LoginModel {
  String? message;
  Data? data;

  LoginModel({required this.message, required this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? idUser;
  String? nama;
  String? username;
  String? password;
  String? level;
  String? foto;
  String? email;
  String? nohp;
  String? jk;
  String? alamat;
  String? blokir;
  String? kodeUnitkerja;
  String? idBidang;

  Data(
      {required this.idUser,
      required this.nama,
      required this.username,
      required this.password,
      required this.level,
      required this.foto,
      required this.email,
      required this.nohp,
      required this.jk,
      required this.alamat,
      required this.blokir,
      required this.kodeUnitkerja,
      required this.idBidang});

  Data.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    nama = json['nama'];
    username = json['username'];
    password = json['password'];
    level = json['level'];
    foto = json['foto'];
    email = json['email'];
    nohp = json['nohp'];
    jk = json['jk'];
    alamat = json['alamat'];
    blokir = json['blokir'];
    kodeUnitkerja = json['kode_unitkerja'];
    idBidang = json['id_bidang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['nama'] = this.nama;
    data['username'] = this.username;
    data['password'] = this.password;
    data['level'] = this.level;
    data['foto'] = this.foto;
    data['email'] = this.email;
    data['nohp'] = this.nohp;
    data['jk'] = this.jk;
    data['alamat'] = this.alamat;
    data['blokir'] = this.blokir;
    data['kode_unitkerja'] = this.kodeUnitkerja;
    data['id_bidang'] = this.idBidang;
    return data;
  }
}

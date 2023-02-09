class LoginModel {
  String? message;
  Data? data;
  Kantor? kantor;
  Jam? jam;
  String? bisaabsen;
  List<Listabsen>? listabsen;
  LoginModel(
      {required this.message,
      required this.data,
      required this.kantor,
      this.jam,
      required this.bisaabsen,
      this.listabsen});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
    kantor =
        json['kantor'] != null ? new Kantor.fromJson(json['kantor']) : null;
    jam = (json['jam'] != null ? new Jam.fromJson(json['jam']) : null);
    bisaabsen = json['bisaabsen'];
    if (json['listabsen'] != null) {
      listabsen = <Listabsen>[];
      json['listabsen'].forEach((v) {
        listabsen!.add(new Listabsen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.kantor != null) {
      data['kantor'] = this.kantor!.toJson();
    }
    if (this.jam != null) {
      data['jam'] = this.jam!.toJson();
    }
    data['bisaabsen'] = this.bisaabsen;
    if (this.listabsen != null) {
      data['listabsen'] = this.listabsen!.map((v) => v.toJson()).toList();
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
  String? idPegawai;
  int? id;
  String? nip;
  String? gd;
  String? gb;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;

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
      required this.idBidang,
      required this.idPegawai,
      required this.id,
      required this.nip,
      required this.gd,
      required this.gb,
      required this.image,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

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
    idPegawai = json['id_pegawai'];
    id = json['id'];
    nip = json['nip'];
    gd = json['gd'];
    gb = json['gb'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['id_pegawai'] = this.idPegawai;
    data['id'] = this.id;
    data['nip'] = this.nip;
    data['gd'] = this.gd;
    data['gb'] = this.gb;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Kantor {
  String? latitude;
  String? longitude;
  String? radius;
  String? namaunitkerja;

  Kantor({this.latitude, this.longitude, this.radius, this.namaunitkerja});

  Kantor.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    namaunitkerja = json['nama_unitkerja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    data['nama_unitkerja'] = this.namaunitkerja;
    return data;
  }
}

class Jam {
  String? idJam;
  String? hari;
  String? kodeUnitkerja;
  String? jenis;
  String? jam;
  String? batas;

  Jam(
      {this.idJam,
      this.hari,
      this.kodeUnitkerja,
      this.jenis,
      this.jam,
      this.batas});

  Jam.fromJson(Map<String, dynamic> json) {
    idJam = json['id_jam'];
    hari = json['hari'];
    kodeUnitkerja = json['kode_unitkerja'];
    jenis = json['jenis'];
    jam = json['jam'];
    batas = json['batas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_jam'] = this.idJam;
    data['hari'] = this.hari;
    data['kode_unitkerja'] = this.kodeUnitkerja;
    data['jenis'] = this.jenis;
    data['jam'] = this.jam;
    data['batas'] = this.batas;
    return data;
  }
}

class Listabsen {
  String? idAbsen;
  String? idPegawai;
  String? kodeUnitkerja;
  String? status;
  String? keterangan;
  String? jenis;
  String? latitude;
  String? longitude;
  String? swafoto;
  String? tglabsen;
  String? file;
  String? noSurat;
  String? time;
  String? masaizin;

  Listabsen(
      {this.idAbsen,
      this.idPegawai,
      this.kodeUnitkerja,
      this.status,
      this.keterangan,
      this.jenis,
      this.latitude,
      this.longitude,
      this.swafoto,
      this.tglabsen,
      this.file,
      this.noSurat,
      this.time,
      this.masaizin});

  Listabsen.fromJson(Map<String, dynamic> json) {
    idAbsen = json['id_absen'];
    idPegawai = json['id_pegawai'];
    kodeUnitkerja = json['kode_unitkerja'];
    status = json['status'];
    keterangan = json['keterangan'];
    jenis = json['jenis'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    swafoto = json['swafoto'];
    tglabsen = json['tglabsen'];
    file = json['file'];
    noSurat = json['no_surat'];
    time = json['time'];
    masaizin = json['masaizin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_absen'] = this.idAbsen;
    data['id_pegawai'] = this.idPegawai;
    data['kode_unitkerja'] = this.kodeUnitkerja;
    data['status'] = this.status;
    data['keterangan'] = this.keterangan;
    data['jenis'] = this.jenis;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['swafoto'] = this.swafoto;
    data['tglabsen'] = this.tglabsen;
    data['file'] = this.file;
    data['no_surat'] = this.noSurat;
    data['time'] = this.time;
    data['masaizin'] = this.masaizin;
    return data;
  }
}

class DetailAbsenModel {
  String? status;
  String? latitude;
  String? longitude;
  String? waktuabsen;
  String? keterangan;

  DetailAbsenModel(
      {this.status,
      this.latitude,
      this.longitude,
      this.waktuabsen,
      this.keterangan});

  DetailAbsenModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    waktuabsen = json['waktuabsen'];
    keterangan = json['keterangan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['waktuabsen'] = this.waktuabsen;
    data['keterangan'] = this.keterangan;
    return data;
  }
}

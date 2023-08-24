class OutLocationModel {
  String? status;
  String? tempat;
  String? start;
  String? end;
  String? qrCode;

  OutLocationModel(
      {this.status, this.tempat, this.start, this.end, this.qrCode});

  OutLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    tempat = json['tempat'];
    start = json['start'];
    end = json['end'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['tempat'] = this.tempat;
    data['start'] = this.start;
    data['end'] = this.end;
    data['qr_code'] = this.qrCode;
    return data;
  }
}

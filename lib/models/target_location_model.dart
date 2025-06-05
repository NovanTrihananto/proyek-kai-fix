class LokasiTrigger {
  Lokasi? lokasi;

  LokasiTrigger({this.lokasi});

  LokasiTrigger.fromJson(Map<String, dynamic> json) {
    lokasi = json['lokasi'] != null ? Lokasi.fromJson(json['lokasi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lokasi != null) {
      data['lokasi'] = lokasi!.toJson();
    }
    return data;
  }
}

class Lokasi {
  String? nama;
  List<LokasiBising>? lokasiBising;

  Lokasi({this.nama, this.lokasiBising});

  Lokasi.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    if (json['lokasi_bising'] != null) {
      lokasiBising = <LokasiBising>[];
      json['lokasi_bising'].forEach((v) {
        lokasiBising!.add(LokasiBising.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama'] = nama;
    if (lokasiBising != null) {
      data['lokasi_bising'] = lokasiBising!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LokasiBising {
  String? nama;
  String? tingkatKebisinganEstimasi;
  String? keterangan;
  double? longitude;
  double? latitude;
  double? triggerRadiusMeter;

  LokasiBising({
    this.nama,
    this.tingkatKebisinganEstimasi,
    this.keterangan,
    this.longitude,
    this.latitude,
    this.triggerRadiusMeter,
  });

  LokasiBising.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    tingkatKebisinganEstimasi = json['tingkat_kebisingan_estimasi'];
    keterangan = json['keterangan'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    triggerRadiusMeter = json['triggerRadiusMeter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama'] = nama;
    data['tingkat_kebisingan_estimasi'] = tingkatKebisinganEstimasi;
    data['keterangan'] = keterangan;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['triggerRadiusMeter'] = triggerRadiusMeter;
    return data;
  }
}

List<LokasiTrigger> triggerListLocation = [
  LokasiTrigger(
    lokasi: Lokasi(
      nama: 'DAOP 6 Yogyakarta',
      lokasiBising: [
        LokasiBising(
          nama: 'LOSD MC',
          tingkatKebisinganEstimasi: 'Tinggi',
          keterangan:
              'Lokasi ini sering digunakan untuk parkir kereta api yang sedang tidak beroperasi.',
          longitude: 110.42275691028573,
          latitude: -7.747996485379148,
          triggerRadiusMeter: 20,
        ),
        LokasiBising(
          nama: 'Depo Kreta Yogyakarta',
          tingkatKebisinganEstimasi: 'Sedang',
          keterangan: '',
          longitude: 110.42275691028573,
          latitude: -7.747996485379148,
          triggerRadiusMeter: 40,
        ),
        LokasiBising(
          nama: 'Depo Kreta maguwo',
          tingkatKebisinganEstimasi: 'Tinggi',
          keterangan: '',
          longitude: 110.4225161,
          latitude: -7.7481928,
          triggerRadiusMeter: 15,
        ),

        LokasiBising(
          nama: 'Depo Traksi Yogyakarta',
          tingkatKebisinganEstimasi: 'Tinggi',
          keterangan: '',
          longitude:  110.36070968332368,
          latitude: -7.788522045271997, 
          triggerRadiusMeter: 15,
        ),
        LokasiBising(
          nama: 'Depo qu Yogyakarta',
          tingkatKebisinganEstimasi: 'Tinggi',
          keterangan: '',
          longitude: 110.326089,
          latitude: -7.801827,
          triggerRadiusMeter: 20,
        ),
        LokasiBising(
          nama: 'Stabling Area',
          tingkatKebisinganEstimasi: 'Sedang',
          keterangan: 'Ini adalah tempat KAI',
          longitude: 110.36116371941888, 
          latitude: -7.788787475069923,    
          triggerRadiusMeter: 35,
        ),
        LokasiBising(
          nama: 'Area',
          tingkatKebisinganEstimasi: 'Sedang',
          keterangan: 'Ini adalah tempat Test Area',
          longitude: 110.36160656166874,
          latitude: -7.788950310786038,   
          triggerRadiusMeter: 14,
        ),
        LokasiBising(
          nama: 'Dipo Lokomotif kereta',
          tingkatKebisinganEstimasi: 'tinggi',
          keterangan: 'Ini adalah tempat Test mesin kereta',
          longitude:  110.36157268407324, 
          latitude: -7.788725341344617,
          triggerRadiusMeter: 10,
        ),
        LokasiBising(
          nama: 'Depo kereta yogya',
          tingkatKebisinganEstimasi: 'tinggi',
          keterangan: 'Ini adalah tempat Test mesin kereta',
          longitude:  110.36183248702578,
          latitude: -7.789051746168483, 
          triggerRadiusMeter: 10,
        ),
         LokasiBising(
          nama: 'Stabil',
          tingkatKebisinganEstimasi: 'Sedang',
          keterangan: 'Ini adalah tempat Test mesin kereta',
          longitude:  110.36191434515389, 
          latitude: -7.788716453983684,   
          triggerRadiusMeter: 27,
        ),
      ],
    ),
  ),
];

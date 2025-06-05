// Perhatikan: File ini diasumsikan sebagai bagian dari screen LBS berbasis Flutter.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kai/models/target_location_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../fitur/edukasi_screen.dart';

class LBS extends StatefulWidget {
  final String? barcode;
  const LBS({super.key, required this.barcode});

  @override
  State<LBS> createState() => _LBSState();
}

class _LBSState extends State<LBS> {
  Position? _currentPosition;
  String _statusMessage = 'Menunggu lokasi...';
  GoogleMapController? _mapController;
  LatLng _initialCameraPosition = const LatLng(-6.200000, 106.816666);
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _sudahBunyikan = false;

  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<String> _triggerStatus = [];

  bool _showWarningDialog = false;
  Timer? _alertTimer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInitSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _showDangerNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'danger_zone_channel',
      'Zona Bahaya',
      channelDescription: 'Notifikasi saat masuk zona kebisingan tinggi',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.red,
      enableVibration: true,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      '⚠️ PERINGATAN!',
      'Anda memasuki zona kebisingan tinggi. Gunakan pelindung telinga!',
      notificationDetails,
    );
  }

  Future<void> _initLocationTracking() async {
    setState(() {
      _statusMessage = 'Mendeteksi lokasi...';
      _triggerStatus.clear();
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Layanan lokasi tidak aktif';
        });
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _statusMessage = 'Izin lokasi ditolak';
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Izin lokasi ditolak permanen';
        });
      }
      return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialCameraPosition, 16),
      );

      _cekTrigger();
    });
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length; j++) {
      int i = (j + 1) % polygon.length;
      if (((polygon[j].latitude > point.latitude) != (polygon[i].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[i].longitude - polygon[j].longitude) *
                      (point.latitude - polygon[j].latitude) /
                      (polygon[i].latitude - polygon[j].latitude) +
                  polygon[j].longitude)) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  void _startAlertSoundLoop() {
    _audioPlayer.play(AssetSource('sounds/alert-109578.mp3'));
    _alertTimer?.cancel();
    _alertTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _audioPlayer.play(AssetSource('sounds/alert-109578.mp3'));
    });
  }

  void _stopAlertSoundLoop() {
    _alertTimer?.cancel();
    _audioPlayer.stop();
  }

  void _showWarningPopup() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.redAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                "Peringatan Zona Merah!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Anda memasuki zona dengan tingkat kebisingan mencapai 110.3 dBA. Segera gunakan pelindung telinga.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _showWarningDialog = false;
                  });
                  _stopAlertSoundLoop();
                  Navigator.of(context).pop();
                  _showAPDPopup();
                },
                child: const Text("LANJUTKAN", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void _showAPDPopup() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.health_and_safety, size: 60, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                "Gunakan APD",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Untuk melindungi pendengaran, gunakan earmuff atau earplug saat berada di zona kebisingan tinggi.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("TUTUP", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EdukasiScreen()),
                      );
                    },
                    child: const Text("LIHAT EDUKASI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}



  Future<void> _cekTrigger() async {
    if (_currentPosition == null) return;

    Set<Marker> newMarkers = {};
    Set<Polygon> newPolygons = {};
    List<String> newStatus = [];

    bool harusBunyi = false;
    bool masukZonaMerah = false;

    for (var lokasiTrigger in triggerListLocation) {
      var lokasi = lokasiTrigger.lokasi;
      if (lokasi == null || lokasi.lokasiBising == null) continue;

      for (var bising in lokasi.lokasiBising!) {
        if (bising.latitude == null || bising.longitude == null) continue;

        double radius = bising.triggerRadiusMeter ?? 50;
        double offset = radius / 111320;

        List<LatLng> polygonPoints = [
          LatLng(bising.latitude! + offset, bising.longitude! - offset),
          LatLng(bising.latitude! + offset, bising.longitude! + offset),
          LatLng(bising.latitude! - offset, bising.longitude! + offset),
          LatLng(bising.latitude! - offset, bising.longitude! - offset),
        ];

        bool isInside = _isPointInPolygon(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          polygonPoints,
        );

        final tingkat = (bising.tingkatKebisinganEstimasi ?? "").toLowerCase();
        String status = "";
        double hue = BitmapDescriptor.hueGreen;
        Color fillColor = Colors.green.withOpacity(0.2);
        Color strokeColor = Colors.green;

        if (tingkat == "tinggi") {
          status = "🔴 ${bising.nama} - Tingkat kebisingan: Tinggi";
          hue = BitmapDescriptor.hueRed;
          fillColor = Colors.red.withOpacity(0.3);
          strokeColor = Colors.red;
        } else if (tingkat == "sedang") {
          status = "🟡 ${bising.nama} - Tingkat kebisingan: Sedang";
          hue = BitmapDescriptor.hueYellow;
          fillColor = Colors.yellow.withOpacity(0.3);
          strokeColor = Colors.yellow;
        } else if (tingkat == "rendah") {
          status = "🟢 ${bising.nama} - Tingkat kebisingan: Rendah";
        }

        newMarkers.add(Marker(
          markerId: MarkerId(bising.nama ?? bising.hashCode.toString()),
          position: LatLng(bising.latitude!, bising.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(title: bising.nama, snippet: bising.keterangan),
        ));

        newPolygons.add(Polygon(
          polygonId: PolygonId('box_${bising.nama}'),
          points: polygonPoints,
          fillColor: fillColor,
          strokeColor: strokeColor,
          strokeWidth: 2,
        ));

        if (isInside) {
          if (status.isNotEmpty) newStatus.add(status);
          if (tingkat == "tinggi") {
            harusBunyi = true;
            masukZonaMerah = true;
          }
        }
      }
    }

    if (masukZonaMerah && !_showWarningDialog) {
      _showWarningDialog = true;
      _startAlertSoundLoop();
      _showWarningPopup();
      await _showDangerNotification();
    } else if (!masukZonaMerah && _showWarningDialog) {
      _showWarningDialog = false;
      _stopAlertSoundLoop();
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
        _polygons = newPolygons;
        _triggerStatus = newStatus;
        _statusMessage = _triggerStatus.isEmpty
            ? "Tidak ada lokasi dalam radius yang terdeteksi"
            : "${_triggerStatus.length} lokasi terdeteksi!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deteksi Lokasi LBS"),
        backgroundColor: const Color(0xFF333232),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCameraPosition,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              polygons: _polygons,
            ),
          ),
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF333232),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_statusMessage, style: const TextStyle(fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 10),
                  ..._triggerStatus.map((status) =>
                      Text(status, style: const TextStyle(fontSize: 14, color: Colors.white70))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

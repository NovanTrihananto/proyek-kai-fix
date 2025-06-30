// Perhatikan: File ini diasumsikan sebagai bagian dari screen LBS berbasis Flutter.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kai/models/target_location_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noise_meter/noise_meter.dart';
import '../fitur/edukasi_screen.dart';
import 'package:permission_handler/permission_handler.dart';

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

  List<double> _noiseBuffer = [];
  final int _bufferDurationInSeconds = 5;
  final double _thresholdDb = 80.0;

  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<String> _triggerStatus = [];

  bool _showWarningDialog = false;
  Timer? _alertTimer;
  Timer? _displayTimer;
  Timer? _noiseCheckTimer;
  List<double> _recentDecibelSamples = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  double _currentDecibel = 0.0;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission().then((_) {
      _initLocationTracking();
      _initNotifications();
      _initNoiseListener();
    });
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _initNoiseListener() {
    _noiseMeter = NoiseMeter();

    try {
      _noiseSubscription = _noiseMeter!.noise.listen((NoiseReading noiseReading) {
        if (!mounted) return;
        _recentDecibelSamples.add(noiseReading.meanDecibel);
      });

      _displayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_recentDecibelSamples.isNotEmpty) {
          double avg = _recentDecibelSamples.reduce((a, b) => a + b) / _recentDecibelSamples.length;
          setState(() {
            _currentDecibel = avg;
          });
          _noiseBuffer.add(avg);
          if (_noiseBuffer.length > _bufferDurationInSeconds) {
            _noiseBuffer.removeAt(0);
          }
          _recentDecibelSamples.clear();
        }
      });

      _noiseCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_noiseBuffer.length >= _bufferDurationInSeconds) {
          bool isConsistentlyLoud = _noiseBuffer.every((db) => db > _thresholdDb);
          if (isConsistentlyLoud && !_showWarningDialog) {
            _showWarningDialog = true;
            _startAlertSoundLoop();
            _showWarningPopup();
            _showDangerNotification();
          } else if (!isConsistentlyLoud && _showWarningDialog) {
            _showWarningDialog = false;
            _stopAlertSoundLoop();
          }
        }
      });

      setState(() {
        _isRecording = true;
      });
    } catch (err) {
      debugPrint("Error starting noise listener: $err");
      setState(() {
        _isRecording = false;
      });
    }
  }

  void onError(Object error) {
    debugPrint("NoiseMeter error: $error");
    setState(() {
      _isRecording = false;
    });
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    _alertTimer?.cancel();
    _displayTimer?.cancel();
    _noiseCheckTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
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
      'Anda memasuki zona kebisingan mencapai 110.3 dBA. Gunakan pelindung telinga!',
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
              const SizedBox(height: 16),
              const Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Text(
                "Peringatan Zona Merah!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Anda memasuki zona dengan tingkat kebisingan mencapai 110.3 dBA. Segera gunakan pelindung telinga.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showWarningDialog = false;
                  });
                  _stopAlertSoundLoop();
                  Navigator.of(context).pop();
                  _showAPDPopup();
                },
                child: const Text(
                  "LANJUTKAN",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
               Image.asset(
                'assets/images/earmuffs.png', // Pastikan gambar ini ada di folder assets/images/
                height: 70,
              ),
              const Text(
                "Gunakan APD",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Untuk melindungi pendengaran, gunakan earmuff atau earplug saat berada di zona kebisingan diatas 110.3 dBA",
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

  double get _safeDecibel {
    if (_currentDecibel.isNaN || _currentDecibel.isInfinite) {
      return 0.0;
    }
    return _currentDecibel;
  }

  double _getPercentage(double decibel) {
    if (decibel.isNaN || decibel.isInfinite) {
      return 0.0;
    }
    return (decibel / 120).clamp(0.0, 1.0);
  }

  int _getPercentageInt(double decibel) {
    if (decibel.isNaN || decibel.isInfinite) {
      return 0;
    }
    double percentage = (decibel / 120 * 100);
    if (percentage.isNaN || percentage.isInfinite) {
      return 0;
    }
    return percentage.round().clamp(0, 100);
  }

  Color _getStatusColor(double decibel) {
    if (decibel.isNaN || decibel.isInfinite || decibel < 0) {
      return Colors.grey;
    }
    if (decibel < 40) return Colors.green;
    if (decibel < 70) return Colors.yellow;
    if (decibel < 80) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(double decibel) {
    if (decibel.isNaN || decibel.isInfinite || decibel < 0) {
      return Icons.signal_cellular_off;
    }
    if (decibel < 40) return Icons.volume_mute;
    if (decibel < 70) return Icons.volume_down;
    if (decibel < 80) return Icons.volume_up;
    return Icons.volume_up;
  }

  String _getStatusText(double decibel) {
    if (decibel.isNaN || decibel.isInfinite || decibel < 0) {
      return "ERROR";
    }
    if (decibel < 40) return "TENANG";
    if (decibel < 70) return "NORMAL";
    if (decibel < 80) return "BERISIK";
    return "SANGAT BERISIK";
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
          status = "🔴 ${bising.nama} - Area Berbahaya! Tingkat kebisingan mencapai 110.3 dBA";
          hue = BitmapDescriptor.hueRed;
          fillColor = Colors.red.withOpacity(0.3);
          strokeColor = Colors.red;
        } else if (tingkat == "sedang") {
          status = "🟡 ${bising.nama} - Area Hati-hati! Tingkat kebisingan mencapai 100.3 dBA";
          hue = BitmapDescriptor.hueYellow;
          fillColor = Colors.yellow.withOpacity(0.3);
          strokeColor = Colors.yellow;
        } else if (tingkat == "rendah") {
          status = "🟢 ${bising.nama} - Anda sedang dalam zona aman kebisingan. Tetap jaga keselamatan";
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
            constraints: const BoxConstraints(minHeight: 160),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2C3E50),
                  const Color(0xFF34495E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header dengan status utama
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_safeDecibel),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(_safeDecibel),
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _getStatusText(_safeDecibel),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.volume_up,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Level kebisingan utama dengan visual yang menarik
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${_safeDecibel.toStringAsFixed(1)}",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    "dBA",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Visual bar indicator
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                widthFactor: _getPercentage(_safeDecibel),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(_safeDecibel),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${_getPercentageInt(_safeDecibel)}%",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Alert status dengan design yang lebih baik
                  if (_triggerStatus.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Alert Aktif",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ..._triggerStatus.map((status) => Padding(
                            padding: const EdgeInsets.only(left: 18, top: 1),
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
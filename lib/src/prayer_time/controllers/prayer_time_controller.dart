import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:quran_app/src/prayer_time/formatters/result_formatter.dart';
import 'package:quran_app/src/prayer_time/models/prayer_time.dart';
import 'package:quran_app/src/widgets/app_permission_status.dart';
import 'package:unicons/unicons.dart';

const api = "https://waktusholat.org/api/docs/today";

class _CurrentLocation {
  double latitude;
  double longitude;

  _CurrentLocation({this.latitude = 0, this.longitude = 0});
}

const String _kLocationServicesDisabledMessage = 'Konum servisi kapalı';
const String _kPermissionDeniedMessage = 'Konum erişimi yetkisi yok.';
const String _kPermissionDeniedForeverMessage =
    "Lütfen konumunuzu açın ve ayarlardan konum erişimi verin.";
const String _kPermissionGrantedMessage = 'Konuma erişilemiyor';

abstract class PrayerTimeController extends GetxController {
  Future<LocationResultFormatter> handleLocationPermission();
  Future<bool> openAppSetting();
  Future<void> getLocation();
  void getPrayerTimesToday(double latitude, double longitude);
  void getAddressLocationDetail(double latitude, double longitude);
}

class PrayerTimeControllerImpl extends PrayerTimeController {
  var currentLocation = _CurrentLocation().obs;
  var prayerTimesToday = PrayerTime().obs;
  var nextPrayer = Prayer.none.obs;
  var currentPrayer = Prayer.none.obs;
  var currentAddress = Placemark().obs;
  var leftOver = 0.obs;
  var sensorIsSupported = false.obs;
  var qiblahDirection = 0.0.obs;

  final cT = CountDownController();

  /// Load location state
  var isLoadLocation = false.obs;

  @override
  Future<LocationResultFormatter> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResultFormatter(false, _kLocationServicesDisabledMessage);
    }

    // check permission location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResultFormatter(false, _kPermissionDeniedMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResultFormatter(false, _kPermissionDeniedForeverMessage);
    }

    return LocationResultFormatter(true, _kPermissionGrantedMessage);
  }

  @override
  Future<bool> openAppSetting() async {
    final opened = await Geolocator.openAppSettings();
    if (opened) {
      log("Konum servisini açınız");
    } else {
      log("Konum servisine erişilemedi.");
    }

    return opened;
  }

  @override
  Future<void> getLocation() async {
    // enabled load location state
    isLoadLocation.value = true;
    final handlePermission = await handleLocationPermission();

    if (!handlePermission.result) {
      Get.bottomSheet(
        AppPermissionStatus(
          icon: UniconsLine.map_marker_slash,
          title: "Konum erişimine izin verin",
          message: handlePermission.error.toString(),
          onPressed: () {
            final prayerC = Get.find<PrayerTimeControllerImpl>();
            prayerC.openAppSetting().then((value) {
              if (!value) {
                Get.snackbar("Eyvah", "Ayarlar açılamıyor");
              }
            });
          },
        ),
      );
    } else {
      final location = await Geolocator.getCurrentPosition();
      var loc = _CurrentLocation(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      currentLocation(loc);
      getPrayerTimesToday(location.latitude, location.longitude);
      getAddressLocationDetail(location.latitude, location.longitude);

      // disabled load location state
      isLoadLocation.value = false;

      getQiblah(location.latitude, location.longitude);
    }
  }

  @override
  void getPrayerTimesToday(double latitude, double longitude) {
    log(latitude.toString());
    log(longitude.toString());

    final myCoordinates = Coordinates(latitude, longitude);

    final params = CalculationMethod.turkey.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);
    final sunnahTimes = SunnahTimes(prayerTimes);

    log("Konum erişimi başarılı - (${prayerTimes.fajr.timeZoneName})---");

    var result = PrayerTime(
      shubuh: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhur: prayerTimes.dhuhr,
      ashar: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isya: prayerTimes.isha,
      middleOfTheNight: sunnahTimes.middleOfTheNight,
      lastThirdOfTheNight: sunnahTimes.lastThirdOfTheNight,
    );

    currentPrayer(prayerTimes.currentPrayer());
    log("Geçerli vakit: ${prayerTimes.currentPrayer()}");

    nextPrayer(prayerTimes.nextPrayer());
    log("Sıradaki vakit: ${prayerTimes.nextPrayer()}");

    prayerTimesToday(result);
    prayerTimesToday.value = result;
  }

  @override
  void getAddressLocationDetail(double latitude, double longitude) async {
    List<Placemark> placeMarks;
    try {
      log("$latitude");
      log("$longitude");
      placeMarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      var address = placeMarks[0];

      log("$address");
      currentAddress(address);
    } on PlatformException catch (e) {
      log(e.toString());
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        placeMarks = await placemarkFromCoordinates(latitude, longitude);
        var address = placeMarks[0];

        log("$address");
        currentAddress(address);
      } catch (e) {
        Get.snackbar("Eyvah", 'Adres alınamadı.');
      }
    }
  }

  var isQiblahLoaded = false.obs;

  void getQiblah(double latitude, double longitude) {
    final myCoordinates = Coordinates(latitude, longitude);

    final qiblah = Qibla(myCoordinates);
    log("Kıble: ${qiblah.direction}");
    qiblahDirection.value = qiblah.direction;
  }

  Future<void> checkDeviceSensorSupport() async {
    FlutterQiblah.androidDeviceSensorSupport().then((value) {
      if (value != null && value) {
        sensorIsSupported.value = value;
        isQiblahLoaded.value = true;
      }
      log("Kontrol $value");
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await getLocation();
    // await Future.delayed(1.seconds);
  }
}


import 'package:firebase_database/firebase_database.dart';

sealed class Meta {}

class OtpMeta extends Meta {
  OtpMeta(this.WA, this.citcallSMS, this.IMS);

  OtpMeta.fromSnapshot(DataSnapshot s)
      : WA = s.child('7225a2a6-b1f7-4c1d-ad6f-219b1bb2fc23').value as int,
        citcallSMS = s.child('385c161b-3c94-446d-a94d-04f6f806ce0a').value as int,
        IMS = s.child('2e098d64-4049-458b-ab72-759e12642f1f').value as int;

  ///7225a2a6-b1f7-4c1d-ad6f-219b1bb2fc23
  final int WA;
  ///385c161b-3c94-446d-a94d-04f6f806ce0a
  final int citcallSMS;
  ///2e098d64-4049-458b-ab72-759e12642f1f
  final int IMS;
}

class FazpassMeta extends Meta {
  FazpassMeta(this.application, this.client_ip, this.platform, this.fazpass_id,
      this.time_stamp, this.is_active, this.is_app_tempering, this.is_clone_app,
      this.is_debug, this.is_emulator, this.is_gps_spoof, this.is_rooted,
      this.is_screen_sharing, this.is_vpn, this.device_id, this.geolocation);

  FazpassMeta.fromSnapshot(DataSnapshot s)
      : application = s.child('application').value as String,
        client_ip = s.child('client_ip').value as String,
        platform = s.child('platform').value as String,
        fazpass_id = s.child('fazpass_id').value as String,
        time_stamp = s.child('time_stamp').value as String,
        is_active = s.child('is_active').value as bool,
        is_app_tempering = s.child('is_app_tempering').value as bool,
        is_clone_app = s.child('is_clone_app').value as bool,
        is_debug = s.child('is_debug').value as bool,
        is_emulator = s.child('is_emulator').value as bool,
        is_gps_spoof = s.child('is_gps_spoof').value as bool,
        is_rooted = s.child('is_rooted').value as bool,
        is_screen_sharing = s.child('is_screen_sharing').value as bool,
        is_vpn = s.child('is_vpn').value as bool,
        device_id = FazpassMetaDevice.fromSnapshot(s.child('device_id')),
        geolocation = FazpassMetaGeolocation.fromSnapshot(s.child('geolocation'));

  final String application;
  final String client_ip;
  final String platform;
  final String fazpass_id;
  final String time_stamp;
  final bool is_active;
  final bool is_app_tempering;
  final bool is_clone_app;
  final bool is_debug;
  final bool is_emulator;
  final bool is_gps_spoof;
  final bool is_rooted;
  final bool is_screen_sharing;
  final bool is_vpn;
  final FazpassMetaDevice device_id;
  final FazpassMetaGeolocation geolocation;
}

class FazpassMetaDevice {
  FazpassMetaDevice(this.cpu, this.name, this.os_version, this.series);

  FazpassMetaDevice.fromSnapshot(DataSnapshot s)
      : cpu = s.child('cpu').value as String,
        name = s.child('name').value as String,
        os_version = s.child('os_version').value as String,
        series = s.child('series').value as String;

  final String cpu;
  final String name;
  final String os_version;
  final String series;
}

class FazpassMetaGeolocation {
  FazpassMetaGeolocation(this.distance, this.lat, this.lng, this.time);

  FazpassMetaGeolocation.fromSnapshot(DataSnapshot s)
      : distance = s.child('distance').value as String,
        lat = s.child('lat').value as String,
        lng = s.child('lng').value as String,
        time = s.child('time').value as String;

  final String distance;
  final String lat;
  final String lng;
  final String time;
}
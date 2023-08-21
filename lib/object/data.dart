
import 'package:firebase_database/firebase_database.dart';
import 'package:tdv2_showcase_web/object/meta.dart';

sealed class Data {}

class ExpectedEntryData extends Data {
  ExpectedEntryData(this.lastType);

  final String lastType;

  String get expectedType {
    switch (lastType.toLowerCase()) {
      case 'check':
      case 'request otp':
        return 'Enroll';
      case 'enroll':
        return 'Validate';
      case 'validate':
        return 'Remove';
      case 'remove':
        return 'Check';
      default:
        return 'None';
    }
  }
}

class EntryData extends Data {
  EntryData(this.key, this.timestamp, this.type, this.meta);

  EntryData.fromSnapshot(DataSnapshot s)
      : key = s.key!,
        timestamp = s.child('timestamp').value as int,
        type = s.child('type').value as String,
        meta = (s.child('type').value as String).toLowerCase().contains('otp')
            ? OtpMeta.fromSnapshot(s.child('meta'))
            : FazpassMeta.fromSnapshot(s.child('meta'));

  final String key;
  final int timestamp;
  final String type;
  final Meta? meta;
  bool shouldAnimate = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryData && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
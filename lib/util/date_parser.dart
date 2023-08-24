
import 'package:timezone/browser.dart' as tz;

import 'constants.dart';

class DateParser {

  static millisDateToDisplay(int millis) {
    String dateString = tz.TZDateTime.fromMillisecondsSinceEpoch(Constants.jakarta, millis).toString();
    String firstPart = dateString.split(':')[0];
    String secondPart = dateString.split(':')[1];
    return '$firstPart:$secondPart';
  }

  static nowDateToDisplay() {
    String dateString = tz.TZDateTime.from(DateTime.now(), Constants.jakarta).toString();
    String firstPart = dateString.split(':')[0];
    String secondPart = dateString.split(':')[1];
    return '$firstPart:$secondPart';
  }
}
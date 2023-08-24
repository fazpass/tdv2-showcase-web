
class DateParser {

  static dateToDisplay(String dateString) {
    String firstPart = dateString.split(' ')[0];
    String secondPart = dateString.split(' ')[1];
    String second1stPart = secondPart.split(':')[0];
    String second2ndPart = secondPart.split(':')[1];
    return '$firstPart $second1stPart:$second2ndPart';
  }
}
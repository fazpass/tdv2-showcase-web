
import 'package:timezone/browser.dart' as tz;

class Constants {
  /// in milliseconds
  static const entryViewAnimationDuration = 1000;

  static const entryViewLoadingMessages = {
    'Check': [
      'Extracting Data...',
      'Querying Data...',
      'Completed.',
    ],
    'Enroll': [
      'Extracting Data...',
      'Registering Data...',
      'Completed.',
    ],
    'Validate': [
      'Extracting Data...',
      //'Clustering User...',
      //'Labeling User...',
      'Classify Behaviour...',
      'Completed.',
    ],
    'Remove': [
      'Removing User...',
      'Completed.',
    ],
  };

  static late tz.Location jakarta;
}
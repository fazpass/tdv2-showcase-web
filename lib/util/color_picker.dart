
import 'package:flutter/material.dart';

class ColorPicker {

  static Color pickColorByDataType(String type) {
    switch (type) {
      case 'Check': return Colors.green;
      case 'Enroll': return Colors.yellow.shade600;
      case 'Validate': return Colors.purpleAccent;
      case 'Remove': return Colors.red;
      default: return Colors.green;
    }
  }
}
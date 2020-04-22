import 'dart:ui';

import 'package:flutter/material.dart';

class UiUtils {
  static Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;

      default:
        return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';

class WeatherIconHelper {
  static IconData getIcon(String iconCode) {
    if (iconCode.startsWith('01')) {
      return Icons.wb_sunny;
    }
    if (iconCode.startsWith('02')) {
      return Icons.wb_cloudy;
    }
    if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
      return Icons.cloud;
    }
    if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      return Icons.beach_access;
    }
    if (iconCode.startsWith('11')) {
      return Icons.flash_on;
    }
    if (iconCode.startsWith('13')) {
      return Icons.ac_unit;
    }
    if (iconCode.startsWith('50')) {
      return Icons.blur_on;
    }
    return Icons.wb_cloudy;
  }
}

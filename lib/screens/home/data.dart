import 'package:flutter/material.dart';


class AppUsageData {
  final String appName;
  final String duration;
  final IconData icon;
  final double progress;
  final Color color;

  AppUsageData({
    required this.appName,
    required this.duration,
    required this.icon,
    required this.progress,
    required this.color,
  });
}
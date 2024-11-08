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

// Sample data that can be accessed throughout the app
final List<AppUsageData> appUsageList = [
  AppUsageData(
    appName: 'Instagram',
    duration: '2h 15m',
    icon: Icons.photo_camera_outlined,
    progress: 0.8,
    color: Colors.pink,
  ),
  AppUsageData(
    appName: 'Twitter',
    duration: '1h 45m',
    icon: Icons.message_outlined,
    progress: 0.6,
    color: Colors.blue,
  ),
  AppUsageData(
    appName: 'YouTube',
    duration: '1h 30m',
    icon: Icons.play_circle_outline,
    progress: 0.5,
    color: Colors.red,
  ),
];
// models.dart
import 'package:flutter/material.dart';

class WeeklyStats {
  final String duration;
  final String percentage;
  final bool isIncrease;

  WeeklyStats({
    required this.duration,
    required this.percentage,
    required this.isIncrease,
  });
}

class TaskProgress {
  final int completed;
  final int total;

  TaskProgress({
    required this.completed,
    required this.total,
  });

  double get progressPercentage => completed / total;
}

class AppUsageData {
  final String appName;
  final String duration;
  // final String iconName;
  final double progress;
  final Color color;

  AppUsageData({
    required this.appName,
    required this.duration,
    // required this.iconName,
    required this.progress,
    required this.color,
  });
}

class WellbeingData {
  final WeeklyStats weeklyStats;
  final TaskProgress taskProgress;
  final List<AppUsageData> appUsage;

  WellbeingData({
    required this.weeklyStats,
    required this.taskProgress,
    required this.appUsage,
  });
}
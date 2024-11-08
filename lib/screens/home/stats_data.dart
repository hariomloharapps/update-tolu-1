import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tolu_7/data/database/database_helper.dart';
import 'package:tolu_7/data/models/todo.dart';

class WeeklyAverageData {
  final String duration;
  final double percentageChange;
  final bool isIncrease;

  WeeklyAverageData({
    required this.duration,
    required this.percentageChange,
    required this.isIncrease,
  });
}

class TasksData {
  final int completedTasks;
  final int totalTasks;
  final double progress;

  TasksData({
    required this.completedTasks,
    required this.totalTasks,
  }) : progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;

  String get taskRatio => '$completedTasks/$totalTasks';
}

// Sample data
final weeklyAverageData = WeeklyAverageData(
  duration: '6h 23m',
  percentageChange: 15,
  isIncrease: false,
);
//
final tasksData = TasksData(
  completedTasks: 1,
  totalTasks: 1,
);



// Future<TasksData> getTasksData() async {
//   try {
//     Database db = await database;
//
//     // Get total count
//     final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM $todoTable');
//     final totalTasks = Sqflite.firstIntValue(totalResult) ?? 0;
//
//     // Get completed count
//     final completedResult = await db.rawQuery(
//         'SELECT COUNT(*) as count FROM $todoTable WHERE isCompleted = 1'
//     );
//     final completedTasks = Sqflite.firstIntValue(completedResult) ?? 0;
//
//     return TasksData(
//       completedTasks: completedTasks,
//       totalTasks: totalTasks,
//     );
//   } catch (e) {
//     // Log error or handle appropriately
//     rethrow;
//   }
// }


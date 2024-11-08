
// lib/data/models/tasks_data.dart
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
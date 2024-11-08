import 'package:flutter/material.dart';
import 'stats_data.dart';

class TasksCard extends StatelessWidget {
  final TasksData data;

  const TasksCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Tasks',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                data.taskRatio,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildProgressIndicator(context),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0, end: data.progress),
      curve: Curves.easeOutCubic,
      builder: (context, double value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
            minHeight: 4,
          ),
        );
      },
    );
  }
}
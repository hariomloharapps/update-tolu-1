import 'package:flutter/material.dart';
import 'stats_data.dart';

class WeeklyAverageCard extends StatelessWidget {
  final WeeklyAverageData data;

  const WeeklyAverageCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Average',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                data.duration,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildChangeIndicator(context),
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(BuildContext context) {
    final text = '${data.isIncrease ? '+' : '-'}${data.percentageChange}% vs last week';
    final color = data.isIncrease ? Colors.green : Colors.red;

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
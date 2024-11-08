import 'package:flutter/material.dart';
import 'app_usage_data.dart';

class UsageWidgets {
  static Widget buildAnimatedCard({
    required Widget child,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  static Widget buildAnimatedPercentage(String text, Color color, BuildContext context) {
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

  static Widget buildAnimatedAppUsageList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Most Used Apps',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Last 7 days',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(
          appUsageList.length,
              (index) => Column(
            children: [
              buildAnimatedAppUsageItem(
                context,
                appUsageList[index],
                delay: index * 200,
              ),
              if (index < appUsageList.length - 1)
                const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildAnimatedAppUsageItem(
      BuildContext context,
      AppUsageData data, {
        required int delay,
      }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 20, color: data.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.appName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          data.duration,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: data.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: data.progress),
                      curve: Curves.easeOutCubic,
                      builder: (context, double value, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: data.color.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(data.color),
                            minHeight: 4,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
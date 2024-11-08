import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.background,
      title: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                Text(
                  'Digital Wellbeing',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.easeOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Hero(
                tag: 'profile',
                child: Icon(
                  Icons.person_outline_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
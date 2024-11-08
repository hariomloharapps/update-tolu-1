import 'package:flutter/material.dart';
import 'package:tolu_7/screens/home/stats_data.dart';
import 'package:tolu_7/screens/home/tasks_card.dart';
import 'package:tolu_7/screens/home/weekly_average_card.dart';
import ' animated_welcome_text.dart';
import 'custom_app_bar.dart';
import 'usage_widgets.dart';
import 'app_usage_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool showContent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    showContent = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onWelcomeAnimationComplete(bool wasFirstTime) {
    if (wasFirstTime) {
      // If it was first time, animate in the content
      setState(() {
        showContent = true;
      });
      _controller.forward();
    } else {
      // If not first time, show content immediately
      setState(() {
        showContent = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const CustomAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [




                  // Top Stats Row with staggered animation
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        // Weekly Average Time Card
                        Expanded(
                          child: TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0, end: 1),
                            curve: Curves.easeOutCubic,
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: WeeklyAverageCard(data: weeklyAverageData),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Todo Progress Card
                        Expanded(
                          child: TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0, end: 1),
                            curve: Curves.easeOutCubic,
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: TasksCard(data: tasksData),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Most Used Apps Card with staggered animation
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: UsageWidgets.buildAnimatedCard(
                      child: UsageWidgets.buildAnimatedAppUsageList(context),
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
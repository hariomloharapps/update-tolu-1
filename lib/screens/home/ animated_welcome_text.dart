import 'package:flutter/material.dart';
// import 'package:shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AnimatedWelcomeText extends StatefulWidget {
  final Function(bool) onAnimationComplete;

  const AnimatedWelcomeText({
    Key? key,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<AnimatedWelcomeText> createState() => _AnimatedWelcomeTextState();
}

class _AnimatedWelcomeTextState extends State<AnimatedWelcomeText> {
  final String fullText = "Welcome to Digital Wellbeing! Let's manage your digital lifestyle together and create healthy habits.";
  String displayedText = "";
  bool hasSeenIntro = false;
  double containerHeight = 0;
  final double finalHeight = 100; // Adjust this based on your needs

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;

    if (!hasSeenIntro) {
      startTypingAnimation();
    } else {
      // If not first time, show full text immediately
      setState(() {
        displayedText = fullText;
        containerHeight = finalHeight;
      });
      widget.onAnimationComplete(false);
    }
  }

  void startTypingAnimation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      containerHeight = finalHeight;
    });

    for (int i = 0; i <= fullText.length; i++) {
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() {
          displayedText = fullText.substring(0, i);
        });
      }
    }

    // Save that user has seen the intro
    await prefs.setBool('has_seen_intro', true);
    if (mounted) {
      widget.onAnimationComplete(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          height: containerHeight,
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
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                displayedText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  height: 1.5,
                ),
              ),
            ),
          ),

        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
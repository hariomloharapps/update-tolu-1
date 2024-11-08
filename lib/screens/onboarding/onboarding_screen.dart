// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences.dart';
import '../../permitions/usage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    // Add observer to detect when app comes back to foreground
    WidgetsBinding.instance.addObserver(this);
    // Check if we already have permission on start
    _checkInitialPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkInitialPermission() async {
    final permissionService = UsagePermissionService();
    final hasPermission = await permissionService.checkPermission();

    if (hasPermission && mounted) {
      final prefs = await SharedPreferences.getInstance();
      final showHome = prefs.getBool('showHome') ?? false;
      if (showHome) {
        // If we have permission and onboarding was completed, go to home
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check permission when app is resumed
      _checkAndNavigate();
    }
  }

  Future<void> _checkAndNavigate() async {
    final permissionService = UsagePermissionService();
    final hasPermission = await permissionService.checkPermission();

    if (hasPermission && mounted) {
      // Save that onboarding is complete
      await _completeOnboarding();
      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showHome', true);
  }

  Future<void> _handlePermissionRequest() async {
    final permissionService = UsagePermissionService();
    final hasPermission = await permissionService.checkPermission();

    if (hasPermission && mounted) {
      await _completeOnboarding();
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      await permissionService.requestPermission();
      // Permission request will open settings, app will be paused
      // When resumed, didChangeAppLifecycleState will handle the check
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 1;
              });
            },
            children: [
              // Welcome Page
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timeline_rounded,
                      size: 120,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Welcome to ProductiTask',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your personal productivity companion that helps you stay focused and organized',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    FilledButton.icon(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Get Started'),
                    ),
                  ],
                ),
              ),

              // Permission Page
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.security_rounded,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'App Usage Permission',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'To help you track and improve your productivity, we need permission to access app usage statistics.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: Icon(Icons.check_circle_outline, color: colorScheme.primary),
                      title: Text('Track app usage time'),
                      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle_outline, color: colorScheme.primary),
                      title: Text('Identify productivity patterns'),
                      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 48),
                    FilledButton.icon(
                      onPressed: _handlePermissionRequest,
                      icon: const Icon(Icons.security_rounded),
                      label: const Text('Grant Permission'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Page Indicator
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !_isLastPage ? colorScheme.primary : colorScheme.outline,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isLastPage ? colorScheme.primary : colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
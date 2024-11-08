// lib/main.dart
import 'package:flutter/material.dart';
import 'package:tolu_7/screens/onboarding/onboarding_screen.dart';
import 'navigation/app_navigation.dart';
import 'screens/splash/splash_screen.dart';
import 'theme.dart';  // Import your theme file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create instance of MaterialTheme with default TextTheme
    final materialTheme = MaterialTheme(Typography.material2021().black);

    return MaterialApp(
      title: 'ProductiTask',
      debugShowCheckedModeBanner: false,

      // Use your custom theme
      theme: materialTheme.light(),      // Light theme
      darkTheme: materialTheme.dark(),   // Dark theme
      themeMode: ThemeMode.system,       // Let system decide theme

      // Define your app routes
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const AppNavigation(),
        // Add other routes as we create more screens
        // '/onboarding': (context) => const OnboardingScreen(),
        // '/home': (context) => const HomeScreen(),
      },
    );
  }
}
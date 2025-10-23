import 'package:dejurebook/pages/on_boarding/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate after build completes
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingPage()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Image.asset(
          'assets/logos/main_logo.png',
          width: 267,
          height: 62,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

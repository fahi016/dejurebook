import 'dart:async';
import 'package:dejurebook/pages/on_boarding/on_boarding_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 2 seconds, then navigate
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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

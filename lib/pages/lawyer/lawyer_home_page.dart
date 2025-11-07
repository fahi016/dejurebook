import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        title: const Text(
          'Awaaz for Lawyers',
          style: TextStyle(
            color: AppColors.blackShade60,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome back, Counsel! Your dashboard will live here soon.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}

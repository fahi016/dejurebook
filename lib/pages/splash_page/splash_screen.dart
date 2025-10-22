import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(
          width: 267,
          height: 62,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.black,
              width: 1.0,
            ),
          ),
          child: const Center(
            child: Text(
              'deJureBook™',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

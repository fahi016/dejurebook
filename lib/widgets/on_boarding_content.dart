import 'package:flutter/material.dart';

class OnBoardingContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnBoardingContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Image.asset(
          'assets/logos/main_logo.png',
          height: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),

        // Center Image
        Image.asset(
          imagePath,
          width: 375,
          height: 320,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 40),

        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.4,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

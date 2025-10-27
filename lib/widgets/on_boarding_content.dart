import 'package:flutter/material.dart';
import 'package:dejurebook/constants/responsive_utils.dart';

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
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/logos/main_logo.png',
            height: ResponsiveUtils.getResponsiveFontSize(context, 60),
            fit: BoxFit.contain,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 30)),

          // Center Image
          Image.asset(
            imagePath,
            width: ResponsiveUtils.getScreenWidth(context) * 0.8,
            height: ResponsiveUtils.getScreenHeight(context) * 0.35,
            fit: BoxFit.contain,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 40)),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),

          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 30),
            ),
            child: Text(
              description,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

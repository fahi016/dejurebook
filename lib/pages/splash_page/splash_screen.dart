import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/on_boarding/on_boarding_page.dart';
import 'package:dejurebook/pages/user_selection/user_selection.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/utils/auth_navigation_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is authenticated
    final isAuthenticated = AuthService.isAuthenticated;

    if (isAuthenticated) {
      final destination = await AuthNavigationHelper.determinePostAuthDestination();
      if (!mounted) return;

      if (destination != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserSelection()),
        );
      }
    } else {
      // User is not signed in, go to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Image.asset(
          'assets/logos/main_logo.png',
          width: ResponsiveUtils.getResponsiveFontSize(context, 267),
          height: ResponsiveUtils.getResponsiveFontSize(context, 62),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

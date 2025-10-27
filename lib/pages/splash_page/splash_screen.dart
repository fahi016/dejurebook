import 'package:dejurebook/pages/on_boarding/on_boarding_page.dart';
import 'package:dejurebook/pages/user_selection/user_selection.dart';
import 'package:dejurebook/pages/consumer/consumer_home_page.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
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
      try {
        // Check if user has completed profile and selected user type
        final profile = await ProfileService.getCurrentUserProfile();
        debugPrint(
            'Profile loaded in splash: ${profile?.userType}, ${profile?.fullName}');

        if (profile != null &&
            profile.userType != null &&
            profile.userType!.isNotEmpty) {
          // User has completed setup, go to home page
          debugPrint('User has completed setup, going to home');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ConsumerHomePage()),
          );
        } else {
          // User is authenticated but hasn't selected user type, go to user selection
          debugPrint('User needs to select type');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UserSelection(),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error loading profile in splash: $e');
        // Error loading profile, assume user needs to complete setup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserSelection(),
          ),
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

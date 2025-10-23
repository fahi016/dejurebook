import 'package:dejurebook/pages/user_selection/user_selection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dejurebook/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _handleGoogleLogin(BuildContext context) {
    Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const UserSelection()),
);
  }

  void _handlePhoneLogin(BuildContext context) {
    Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const UserSelection()),
);

  }

  void _navigateToTerms(BuildContext context) {
    // TODO: Navigate to Terms page
    print('Navigate to Terms');
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    // TODO: Navigate to Privacy Policy page
    print('Navigate to Privacy Policy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 120),

              // DeJureBook Logo
              Image.asset(
                'assets/logos/main_logo.png',
                width: 240,
                height: 56,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Law Image
              Image.asset(
                'assets/images/law_image.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 50),

              // Login with Google Button
              AuthButton(
                text: 'Login with Google',
                icon: Icons.g_mobiledata_rounded,
                iconSize: 35,
                onPressed: () => _handleGoogleLogin(context),
              ),

              const SizedBox(height: 16),

              // Login with Phone Button
              AuthButton(
                text: 'Login with Phone',
                icon: Icons.phone,
                onPressed: () => _handlePhoneLogin(context),
              ),

              const Spacer(),

              // Terms and Privacy Policy Text
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'By clicking Login, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _navigateToTerms(context),
                      ),
                      const TextSpan(
                        text: ' and acknowledge that\nyou have read our ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _navigateToPrivacyPolicy(context),
                      ),
                      const TextSpan(
                        text:
                            ', which explains how to opt out of offers and promos.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

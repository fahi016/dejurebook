import 'package:dejurebook/pages/user_selection/user_selection.dart';
import 'package:dejurebook/pages/auth/complete_profile_screen.dart';
import 'package:dejurebook/pages/consumer/consumer_home_page.dart';
import 'package:dejurebook/bloc/auth_bloc.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/widgets/auth_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() {
    // Check if user is already authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAuthenticated = AuthService.isAuthenticated;
      if (isAuthenticated && mounted) {
        // User is already signed in, go to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ConsumerHomePage(),
          ),
        );
      }
    });
  }

  void _handleGoogleLogin(BuildContext context) {
    context.read<AuthBloc>().add(AuthGoogleSignInRequested());
  }

  void _handlePhoneLogin(BuildContext context) {
    _showPhoneLoginDialog(context);
  }

  void _showPhoneLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PhoneLoginDialog(),
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthAuthenticated) {
          // Check if user has a user_type set
          final profile = await ProfileService.getCurrentUserProfile();
          if (profile?.userType != null) {
            // User already has a type, go to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ConsumerHomePage()),
            );
          } else {
            // User needs to select type
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserSelection()),
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
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

                // Login with email Button
                AuthButton(
                  text: 'Login with email',
                  icon: Icons.email,
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
      ),
    );
  }
}

class PhoneLoginDialog extends StatefulWidget {
  const PhoneLoginDialog({super.key});

  @override
  State<PhoneLoginDialog> createState() => _PhoneLoginDialogState();
}

class _PhoneLoginDialogState extends State<PhoneLoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pop();

          // Check if user has a user_type set
          final profile = await ProfileService.getCurrentUserProfile();
          if (profile?.userType != null) {
            // User already has a type, go to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ConsumerHomePage()),
            );
          } else {
            // User needs to select type
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserSelection()),
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: AlertDialog(
        title: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isSignUp = !_isSignUp;
              });
            },
            child: Text(_isSignUp
                ? 'Already have an account? Sign In'
                : 'Don\'t have an account? Sign Up'),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (_isSignUp) {
                            // Navigate to complete profile screen for new users
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompleteProfileScreen(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              ),
                            );
                          } else {
                            context.read<AuthBloc>().add(
                                  AuthSignInRequested(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        }
                      },
                child: state is AuthLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
              );
            },
          ),
        ],
      ),
    );
  }
}

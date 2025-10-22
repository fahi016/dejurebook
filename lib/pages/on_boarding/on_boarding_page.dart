import 'package:dejurebook/pages/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/widgets/custom_button.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const LoginScreen(), // Replace with your login screen
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  OnBoardingContent(
                    imagePath: 'assets/images/on_boarding_image_1.png',
                    title: 'Legal Scroll Zone',
                    description:
                        'Watch legal short form content – learn the law like never before.',
                  ),
                  OnBoardingContent(
                    imagePath: 'assets/images/on_boarding_image_2.png',
                    title: 'AI Legal Chat Assistant',
                    description:
                        'Ask anything. Understand your rights in your language.',
                  ),
                  OnBoardingContent(
                    imagePath: 'assets/images/on_boarding_image_3.png',
                    title: 'Earn by Sharing Knowledge',
                    description:
                        'Create legal content. Gain followers. Earn money.',
                  ),
                ],
              ),
            ),

            // Dot indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => _buildDot(index == _currentPage),
                ),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: CustomButton(
                text: _currentPage == 0 ? "Get Started" : "Continue",
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 15 : 15,
      height: isActive ? 6 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

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

import 'package:dejurebook/pages/auth/auth_page.dart';
import 'package:dejurebook/pages/on_boarding/bloc/on_boarding_bloc.dart';
import 'package:dejurebook/pages/on_boarding/bloc/on_boarding_event.dart';
import 'package:dejurebook/pages/on_boarding/bloc/on_boarding_state.dart';
import 'package:dejurebook/widgets/on_boarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/widgets/custom_button.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingBloc, OnBoardingState>(
      listener: (context, state) {
        // Navigate when onboarding is completed
        if (state.isCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        // Sync PageController with BLoC state
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentPage) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      context
                          .read<OnBoardingBloc>()
                          .add(PageChangedEvent(index));
                    },
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
                      (index) => _buildDot(
                        context,
                        index == state.currentPage,
                      ),
                    ),
                  ),
                ),

                // Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: CustomButton(
                    text: state.currentPage == 0 ? "Get Started" : "Continue",
                    onPressed: () {
                      context.read<OnBoardingBloc>().add(const NextPageEvent());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDot(BuildContext context, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 15,
      height: 6,
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

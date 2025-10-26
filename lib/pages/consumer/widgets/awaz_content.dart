// awaz_content.dart
import 'package:dejurebook/pages/consumer/widgets/animated_waveform.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/ai_chat/ai_chat_page.dart';
import 'package:flutter/material.dart';

class AwazContent extends StatefulWidget {
  const AwazContent({super.key});

  @override
  State<AwazContent> createState() => _AwazContentState();
}

class _AwazContentState extends State<AwazContent>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _promptController;
  late AnimationController _arrowController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _promptSlideAnimation;
  late Animation<double> _promptFadeAnimation;
  late Animation<double> _arrowAnimation;

  int _currentPromptIndex = 0;
  final List<String> _prompts = [
    "What are my rights?",
    "How do I file a complaint?",
    "Tell me about labor laws",
    "What is the legal process?",
  ];

  bool _isListening = false;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the microphone button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // Arrow bounce animation
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _arrowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _arrowController.repeat(reverse: true);

    // Prompt animation
    _promptController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _promptSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).animate(CurvedAnimation(
      parent: _promptController,
      curve: Curves.easeInOut,
    ));

    _promptFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _promptController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ));

    _startPromptAnimation();
  }

  void _startPromptAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isListening) {
        _promptController.forward().then((_) {
          setState(() {
            _currentPromptIndex = (_currentPromptIndex + 1) % _prompts.length;
          });
          _promptController.reset();
          _startPromptAnimation();
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _promptController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                AppColors.lightGrey,
                AppColors.getSurfaceColor(context),
              ],
            ),
          ),
        ),

        // Main content
        Column(
          children: [
            SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 100)),

            // "Talk here" text with arrow - hidden when listening
            if (!_isListening)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/radio_studio_image.png',
                          width: ResponsiveUtils.getResponsiveFontSize(
                              context, 35),
                          height: ResponsiveUtils.getResponsiveFontSize(
                              context, 35),
                        ),
                      ),
                      SizedBox(
                          width:
                              ResponsiveUtils.getResponsiveSpacing(context, 4)),
                      Text(
                        'Talk here',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context, 18),
                          color: AppColors.getOnSurfaceColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: AnimatedBuilder(
                      animation: _arrowAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _arrowAnimation.value),
                          child: Image.asset(
                            'assets/images/arrow_down_image.png',
                            width: ResponsiveUtils.getResponsiveFontSize(
                                context, 40),
                            height: ResponsiveUtils.getResponsiveFontSize(
                                context, 40),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            // Center microphone with pulse effect
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isListening ? _pulseAnimation.value : 1.0,
                          child: GestureDetector(
                            onTap: _toggleListening,
                            child: Container(
                              width: ResponsiveUtils.getResponsiveFontSize(
                                  context, 200),
                              height: ResponsiveUtils.getResponsiveFontSize(
                                  context, 200),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightGrey,
                                    blurRadius: 15,
                                    spreadRadius: 9,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: EdgeInsets.all(
                                    ResponsiveUtils.getResponsiveSpacing(
                                        context, 20)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.grey,
                                ),
                                child: Image.asset(
                                  'assets/images/equality_image.png',
                                  width: ResponsiveUtils.getResponsiveFontSize(
                                      context, 24),
                                  height: ResponsiveUtils.getResponsiveFontSize(
                                      context, 24),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                        height:
                            ResponsiveUtils.getResponsiveSpacing(context, 80)),

                    // Animated prompts or listening indicator
                    SizedBox(
                      height:
                          ResponsiveUtils.getResponsiveSpacing(context, 100),
                      child: _isListening
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AnimatedWaveform(),
                                SizedBox(
                                    height:
                                        ResponsiveUtils.getResponsiveSpacing(
                                            context, 20)),
                                Text(
                                  'Listening...',
                                  style: TextStyle(
                                    color: AppColors.getOnSurfaceColor(context),
                                    fontSize:
                                        ResponsiveUtils.getResponsiveFontSize(
                                            context, 18),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _promptController,
                                  builder: (context, child) {
                                    return SlideTransition(
                                      position: _promptSlideAnimation,
                                      child: FadeTransition(
                                        opacity: _promptFadeAnimation,
                                        child: Text(
                                          _prompts[_currentPromptIndex],
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils
                                                .getResponsiveFontSize(
                                                    context, 16),
                                            color: AppColors.getOnSurfaceColor(
                                                context),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),

                    // "read conversation here" text link
                    if (_isListening)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AiChatPage(
                                sessionId: 'default_session',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: ResponsiveUtils.getResponsiveSpacing(
                                context, 20),
                          ),
                          child: Text(
                            'read conversation here',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context, 16),
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

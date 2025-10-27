import 'package:dejurebook/pages/messages/bloc/message_bloc.dart';
import 'package:dejurebook/pages/splash_page/splash_screen.dart';
import 'package:dejurebook/pages/on_boarding/bloc/on_boarding_bloc.dart';
import 'package:dejurebook/constants/app_theme.dart';
import 'package:dejurebook/pages/user_selection/bloc/user_selection_bloc.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Optional: Set up BLoC observer for debugging
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

// BLoC Observer for debugging (helps track all BLoC events and states)
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('📍 Event: ${event.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(
        '🔄 Transition: ${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('❌ Error in ${bloc.runtimeType}: $error');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('📝 Change in ${bloc.runtimeType}: $change');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // OnBoarding BLoC
        BlocProvider<OnBoardingBloc>(
          create: (context) => OnBoardingBloc(),
          lazy: true, // Only creates when needed
        ),
        BlocProvider<UserSelectionBloc>(
          create: (context) => UserSelectionBloc(),
          lazy: true, // Only creates when needed
        ),
        BlocProvider<MessageBloc>(
          create: (_) => MessageBloc(),
        ),
        BlocProvider<AiChatBloc>(
          create: (_) => AiChatBloc(),
        ),

        // Add more BLoCs here as your app grows
        // Example:
        // BlocProvider<AuthBloc>(
        //   create: (context) => AuthBloc(),
        // ),
        // BlocProvider<ThemeBloc>(
        //   create: (context) => ThemeBloc(),
        // ),
        // BlocProvider<UserBloc>(
        //   create: (context) => UserBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'DejureBook',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}

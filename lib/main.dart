import 'package:dejurebook/pages/splash_page/splash_screen.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DejureBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: AppColors.lightColorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: AppColors.darkColorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
      ),
      home: const SplashScreen(),
    );
  }
}

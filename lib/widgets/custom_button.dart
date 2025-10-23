import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: onPressed != null
                ? const Color.fromARGB(255, 38, 36, 36) // Active (lighter)
                : const Color.fromARGB(255, 25, 23, 23), // Inactive (darker)
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: onPressed != null ? 8 : 0,
            shadowColor: onPressed != null
                ? Colors.black.withOpacity(0.4)
                : Colors.transparent,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: onPressed != null
                  ? Colors.white
                  : const Color.fromARGB(255, 150, 150,
                      150), // Also made text more gray when disabled
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

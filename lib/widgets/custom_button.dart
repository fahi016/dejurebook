import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isEnabled
                    ? AppColors.getPrimaryColor(context)
                    : AppColors.grey),
            foregroundColor: textColor ??
                (isEnabled ? AppColors.white : AppColors.lightGrey),
            minimumSize: Size(
              width ?? double.infinity,
              height ?? ResponsiveUtils.getResponsiveFontSize(context, 55),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: isEnabled ? 4 : 0,
            shadowColor: isEnabled
                ? AppColors.black.withOpacity(0.2)
                : Colors.transparent,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

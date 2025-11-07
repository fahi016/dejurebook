import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? iconImage;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconImage,
    this.backgroundColor,
    this.textColor,
    this.iconSize,
  }) : assert(icon != null || iconImage != null,
            'Either an icon or iconImage must be provided.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveUtils.getResponsiveFontSize(context, 56),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.darkGrey,
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: AppColors.black.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconImage != null)
              Image.asset(
                iconImage!,
                width: iconSize ??
                    ResponsiveUtils.getResponsiveFontSize(context, 24),
                height: iconSize ??
                    ResponsiveUtils.getResponsiveFontSize(context, 24),
              )
            else if (icon != null)
              Icon(
                icon,
                size: iconSize ??
                    ResponsiveUtils.getResponsiveFontSize(context, 24),
                color: textColor ?? AppColors.white,
              ),
            SizedBox(
              width: ResponsiveUtils.getResponsiveSpacing(context, 12),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

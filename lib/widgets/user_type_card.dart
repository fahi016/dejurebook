import 'package:flutter/material.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/user_selection/bloc/user_selection_event.dart';

class UserTypeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final UserType userType;
  final bool isSelected;
  final VoidCallback onTap;

  const UserTypeCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.userType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 20),
          top: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main card
            Container(
              height: ResponsiveUtils.getResponsiveFontSize(context, 65),
              padding: EdgeInsets.only(
                left: ResponsiveUtils.getResponsiveFontSize(context, 85),
                right: ResponsiveUtils.getResponsiveSpacing(context, 20),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF252525), // Dark gray color
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveSpacing(context, 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isSelected
                    ? Border.all(
                        color: Colors.white,
                        width: 2,
                      )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: ResponsiveUtils.getResponsiveSpacing(context, 20),
                  ),
                  // Title text
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context, 16.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Arrow icon
                  Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(
                      ResponsiveUtils.getResponsiveSpacing(context, 6),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: ResponsiveUtils.getResponsiveFontSize(context, 18),
                    ),
                  ),
                ],
              ),
            ),

            // Circular image - positioned to pop out on the top-left
            Positioned(
              left: ResponsiveUtils.getResponsiveSpacing(context, 10),
              top: -ResponsiveUtils.getResponsiveSpacing(
                  context, 8), // Pops out slightly above the card
              child: Container(
                width: ResponsiveUtils.getResponsiveFontSize(context, 70),
                height: ResponsiveUtils.getResponsiveFontSize(context, 70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: ResponsiveUtils.getResponsiveFontSize(context, 75),
                    height: ResponsiveUtils.getResponsiveFontSize(context, 75),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: ResponsiveUtils.getResponsiveFontSize(
                              context, 30),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

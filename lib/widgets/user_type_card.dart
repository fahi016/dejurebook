import 'package:flutter/material.dart';
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
        margin: const EdgeInsets.only(bottom: 20, top: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main card
            Container(
              height: 65,
              padding: const EdgeInsets.only(left: 85, right: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4A4A4A)
                    : const Color(0xFF3B3B3B),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  // Title text
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Arrow icon
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF595858),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Circular image - positioned to pop out on the top-left
            Positioned(
              left: 10,
              top: -8, // Pops out slightly above the card
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
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

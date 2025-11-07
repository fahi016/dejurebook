import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:dejurebook/models/lawyer_profile.dart';
import 'package:dejurebook/pages/consumer/consumer_home_page.dart';
import 'package:dejurebook/pages/lawyer/lawyer_home_page.dart';
import 'package:dejurebook/pages/lawyer/widgets/complete_lawyer_profile.dart';
import 'package:dejurebook/pages/user_selection/user_selection.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/services/lawyer_profile_service.dart';
import 'package:dejurebook/services/profile_service.dart';

class AuthNavigationHelper {
  const AuthNavigationHelper._();

  static Future<Widget?> determinePostAuthDestination() async {
    final user = AuthService.currentUser;
    if (user == null) {
      debugPrint('AuthNavigationHelper: No authenticated user found.');
      return null;
    }

    try {
      final profile = await ProfileService.getProfile(user.id);
      final userType = profile?.userType?.toLowerCase().trim();

      if (userType == null || userType.isEmpty) {
        return const UserSelection();
      }

      switch (userType) {
        case 'lawyer':
          final lawyerProfile = await LawyerProfileService.fetchProfile(user.id);
          if (!_isLawyerProfileComplete(lawyerProfile)) {
            return const CompleteLawyerProfilePage();
          }
          return const LawyerHomePage();
        case 'consumer':
          return const ConsumerHomePage();
        default:
          return const UserSelection();
      }
    } catch (error, stackTrace) {
      debugPrint('AuthNavigationHelper: Failed to determine destination — '
          '$error\n$stackTrace');
      return const UserSelection();
    }
  }

  static bool _isLawyerProfileComplete(LawyerProfile? profile) {
    if (profile == null) return false;
    final hasDocument = profile.documentUrl != null && profile.documentUrl!.isNotEmpty;
    final hasPracticeAreas = profile.practiceAreas.isNotEmpty;
    final hasAvailability = profile.availability.values.any((slots) => slots.isNotEmpty);
    final hasContactInfo = profile.fullName.isNotEmpty && profile.phoneNumber.isNotEmpty;

    return hasDocument && hasPracticeAreas && hasAvailability && hasContactInfo;
  }
}


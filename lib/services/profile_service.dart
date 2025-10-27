import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dejurebook/models/user_profile.dart';
import 'package:dejurebook/services/supabase_config.dart';

class ProfileService {
  static final SupabaseClient _supabase = SupabaseConfig.client;

  // Create user profile
  static Future<UserProfile> createProfile({
    required String userId,
    required String email,
    String? fullName,
    String? avatarUrl,
    String? userType,
    String? profession,
  }) async {
    try {
      print('Creating profile with data:');
      print('userId: $userId');
      print('email: $email');
      print('fullName: $fullName');
      print('profession: $profession');

      final Map<String, dynamic> insertData = {
        'id': userId,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'user_type': userType,
        'profession': profession,
      };

      print('Insert data: $insertData');

      final response =
          await _supabase.from('profiles').insert(insertData).select().single();

      print('Profile created response: $response');
      final profile = UserProfile.fromJson(response);
      print('Parsed profile: ${profile.fullName}, ${profile.profession}');
      return profile;
    } catch (e) {
      print('Error creating profile: $e');
      throw Exception('Failed to create profile: $e');
    }
  }

  // Get user profile by ID
  static Future<UserProfile?> getProfile(String userId) async {
    try {
      print('Fetching profile for user: $userId');
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      print('Profile response: $response');
      if (response == null) {
        print('No profile found for user: $userId');
        return null;
      }
      final profile = UserProfile.fromJson(response);
      print('Profile loaded: ${profile.fullName}, ${profile.profession}');
      return profile;
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Failed to get profile: $e');
    }
  }

  // Get current user's profile
  static Future<UserProfile?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('No authenticated user');
      return null;
    }
    return getProfile(user.id);
  }

  // Update user profile
  static Future<UserProfile> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
    String? userType,
    String? profession,
  }) async {
    try {
      print('Updating profile with data:');
      print('userId: $userId');
      print('fullName: $fullName');
      print('profession: $profession');
      print('userType: $userType');

      // Only include fields that are not null in the update
      final Map<String, dynamic> updateData = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (userType != null) updateData['user_type'] = userType;
      if (profession != null) updateData['profession'] = profession;

      print('Update data: $updateData');

      final response = await _supabase
          .from('profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      print('Profile updated response: $response');
      final profile = UserProfile.fromJson(response);
      print('Parsed profile: ${profile.fullName}, ${profile.profession}');
      return profile;
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // Update current user's profile
  static Future<UserProfile> updateCurrentUserProfile({
    String? fullName,
    String? avatarUrl,
    String? userType,
    String? profession,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    return updateProfile(
      userId: user.id,
      fullName: fullName,
      avatarUrl: avatarUrl,
      userType: userType,
      profession: profession,
    );
  }

  // Check if profile exists
  static Future<bool> profileExists(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}

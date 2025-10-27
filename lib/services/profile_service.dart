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

      final response = await _supabase
          .from('profiles')
          .insert({
            'id': userId,
            'email': email,
            'full_name': fullName,
            'avatar_url': avatarUrl,
            'user_type': userType,
            'profession': profession,
          })
          .select()
          .single();

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
      final response = await _supabase
          .from('profiles')
          .update({
            'full_name': fullName,
            'avatar_url': avatarUrl,
            'user_type': userType,
            'profession': profession,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
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

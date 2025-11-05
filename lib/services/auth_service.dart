import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dejurebook/services/supabase_config.dart';
// (no extra imports needed for OAuth flow)

class AuthService {
  static final SupabaseClient _supabase = SupabaseConfig.client;

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  // Sign up with email and password
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  static Future<void> signInWithGoogle() async {
    try {
      // Use Supabase OAuth flow with deep link redirect (per docs)
      // Ensure this redirect is whitelisted in Supabase Auth → Redirect URLs
      const redirectUri = 'io.supabase.flutter://login-callback';

      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // Provide common scopes and query params if you need Google refresh tokens
        queryParams: const {
          'access_type': 'offline',
          'prompt': 'consent',
        },
        redirectTo: redirectUri,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  // Update user profile
  static Future<UserResponse> updateProfile({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: data,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}

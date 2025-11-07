import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dejurebook/models/lawyer_profile.dart';
import 'package:dejurebook/services/supabase_config.dart';

class LawyerProfileService {
  LawyerProfileService._();

  static final SupabaseClient _client = SupabaseConfig.client;
  static const String _tableName = 'lawyer_profiles';
  static const String _storageBucket = 'lawyer-documents';

  static Future<LawyerProfile> upsertProfile(LawyerProfile profile) async {
    final payload = profile.toJson()
      ..removeWhere((key, value) => value == null);

    final Map<String, dynamic>? response = await _client
        .from(_tableName)
        .upsert(payload, onConflict: 'user_id')
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Failed to upsert lawyer profile');
    }

    return LawyerProfile.fromJson(response);
  }

  static Future<LawyerProfile?> fetchProfile(String userId) async {
    final Map<String, dynamic>? response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;

    return LawyerProfile.fromJson(response);
  }

  static Future<String> uploadDocument({
    required String userId,
    required String originalFileName,
    required Uint8List fileBytes,
  }) async {
    final sanitizedName = originalFileName.replaceAll(' ', '_');
    final storagePath =
        '${userId}_${DateTime.now().millisecondsSinceEpoch}_$sanitizedName';

    final storage = _client.storage.from(_storageBucket);
    await storage.uploadBinary(storagePath, fileBytes);
    return storage.getPublicUrl(storagePath);
  }
}

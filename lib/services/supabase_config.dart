import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://jayimoyeahnpnmyxafwl.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpheWltb3llYWhucG5teXhhZndsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjE1NTQsImV4cCI6MjA3NzEzNzU1NH0.TTv7Qe93PXCtsXi1tVi7OylqT8AXEEQak3LWxTNvGPc';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

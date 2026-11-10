import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseSetup {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  static Future<void> init() => Supabase.initialize(url: url, publishableKey: anonKey);

  static SupabaseClient get client => Supabase.instance.client;

  static String? get userId => client.auth.currentUser?.id;
}

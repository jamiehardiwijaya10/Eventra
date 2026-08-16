import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> getProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('profiles')
        .select('*, roles(name)')
        .eq('id', user.id)
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    await _client.from('profiles').update(data).eq('id', user.id);
  }

  Future<List<Map<String, dynamic>>> getCustomerEventHistory() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('tickets')
        .select('''
          id,
          event_id,
          status,
          events (
            id,
            title,
            banner,
            start_date,
            end_date,
            venue_name,
            location
          )
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getCustomerBoothHistory() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('reviews')
        .select('''
          id,
          booth_id,
          rating,
          comment,
          created_at,
          booths (
            id,
            name,
            banner,
            event_id,
            events (
              id,
              title,
              banner,
              start_date,
              end_date,
              venue_name
            )
          )
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getEoEventHistory() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('events')
        .select()
        .eq('eo_id', user.id)
        .order('start_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String> uploadProfileAvatar({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final path =
      'avatars/${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

    await _client.storage
      .from('profile_avatars')
      .uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          upsert: true,
        ),
      );

  return _client.storage
      .from('profile_avatars')
      .getPublicUrl(path);
  }
}

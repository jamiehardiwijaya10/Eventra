import 'package:supabase_flutter/supabase_flutter.dart';

class BoothService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> createBooth({
    required String eventId,
    required String name,
    required String description,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('booths')
        .insert({
          'event_id': eventId,
          'owner_id': user.id,
          'name': name,
          'description': description,
          'status': 'pending',
        })
        .select()
        .single();

    return response;
  }
}
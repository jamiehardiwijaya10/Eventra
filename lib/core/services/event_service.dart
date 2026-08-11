import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class EventService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getEvents() async {
    final response = await _client
        .from('events')
        .select()
        .eq('status', 'published')
        .order('start_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String> uploadEventBanner({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final path =
        '${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _client.storage
        .from('event_banner')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

    final publicUrl = _client.storage
        .from('event_banner')
        .getPublicUrl(path);

    return publicUrl;
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required String banner,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String categoryId,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    await _client.from('events').insert({
      'eo_id': user.id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'banner': banner,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': 'published',
    });
  }

  Future<Map<String, dynamic>> getEventById(
    String eventId,
  ) async {
    final response = await _client
        .from('events')
        .select()
        .eq('id', eventId)
        .single();

    return response;
  }

  Future<List<Map<String, dynamic>>> getMyEvents() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('events')
        .select()
        .eq('eo_id', user.id)
        .order('start_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String?> getCategoryIdByName(String categoryName) async {
    final response = await _client
        .from('categories')
        .select('id')
        .eq('name', categoryName)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return response['id']?.toString();
  }
}
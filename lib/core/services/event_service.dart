import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<String> uploadEventImage({
    required Uint8List bytes,
    required String fileName,
    required String folder,
  }) async {
    final path =
        '$folder/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _client.storage
        .from('event_banner')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

    return _client.storage
        .from('event_banner')
        .getPublicUrl(path);
  }

  Future<String> uploadEventBanner({
    required Uint8List bytes,
    required String fileName,
  }) async {
    return uploadEventImage(
      bytes: bytes,
      fileName: fileName,
      folder: 'banners',
    );
  }

  Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required String banner,
    required String logo,
    required String location,
    required double latitude,
    required double longitude,
    required String venueName,
    required String eventType,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay openingTime,
    required TimeOfDay closingTime,
    required DateTime registrationDeadline,
    required int registrationFee,
    required int maximumBooth,
    required String categoryId,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('events')
        .insert({
          'eo_id': user.id,
          'category_id': categoryId,
          'title': title,
          'description': description,
          'banner': banner,
          'logo': logo,
          'venue_name': venueName,
          'location': location,
          'latitude' : latitude,
          'longitude' : longitude,
          'event_type': eventType,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'opening_time':
              '${openingTime.hour.toString().padLeft(2, '0')}:'
              '${openingTime.minute.toString().padLeft(2, '0')}:00',
          'closing_time':
              '${closingTime.hour.toString().padLeft(2, '0')}:'
              '${closingTime.minute.toString().padLeft(2, '0')}:00',
          'registration_deadline':
              registrationDeadline.toIso8601String(),
          'registration_fee': registrationFee,
          'maximum_booth': maximumBooth,
          'visitor_count': 0,
          'status': 'published',
        })
        .select()
        .single();

    return response;
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

  Future<String?> getCategoryIdByName(
    String categoryName,
  ) async {
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

  Future<List<Map<String, dynamic>>> getEventBooths(
    String eventId,
  ) async {
    final response = await _client
        .from('booths')
        .select()
        .eq('event_id', eventId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateEvent({
    required String eventId,
    required String title,
    required String description,
    required String location,
    required String venueName,
    required String eventType,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay openingTime,
    required TimeOfDay closingTime,
    required DateTime registrationDeadline,
    required int registrationFee,
    required int maximumBooth,
  }) async {
    await _client.from('events').update({
      'title': title,
      'description': description,
      'location': location,
      'venue_name': venueName,
      'event_type': eventType,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'opening_time':
          '${openingTime.hour.toString().padLeft(2, '0')}:${openingTime.minute.toString().padLeft(2, '0')}:00',
      'closing_time':
          '${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}:00',
      'registration_deadline':
          registrationDeadline.toIso8601String(),
      'registration_fee': registrationFee,
      'maximum_booth': maximumBooth,
    }).eq('id', eventId);
  }

  Future<void> deleteEvent(String eventId) async {
    await _client
        .from('events')
        .delete()
        .eq('id', eventId);
  }

  Future<List<Map<String, dynamic>>> getAvailableEvents() async {
    final response = await _client
        .from('events')
        .select()
        .eq('status', 'published')
        .order('start_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPendingBooths(
    String eventId,
  ) async {
    final response = await _client
        .from('booths')
        .select()
        .eq('event_id', eventId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateBoothStatus({
    required String boothId,
    required String status,
  }) async {
    await _client
        .from('booths')
        .update({
          'status': status,
        })
        .eq('id', boothId);
  }

  Future<Map<String, int>> getEventStatistics(
    String eventId,
  ) async {
    final booths = await _client
        .from('booths')
        .select('status')
        .eq('event_id', eventId);

    final totalBooth = booths.length;

    final approvedBooth = booths
        .where(
          (booth) => booth['status'] == 'approved',
        )
        .length;

    final pendingBooth = booths
        .where(
          (booth) => booth['status'] == 'pending',
        )
        .length;

    final rejectedBooth = booths
        .where(
          (booth) => booth['status'] == 'rejected',
        )
        .length;

    final event = await _client
        .from('events')
        .select('visitor_count')
        .eq('id', eventId)
        .single();

    final visitorCount =
        (event['visitor_count'] ?? 0) as int;

    return {
      'totalBooth': totalBooth,
      'approvedBooth': approvedBooth,
      'pendingBooth': pendingBooth,
      'rejectedBooth': rejectedBooth,
      'visitorCount': visitorCount,
    };
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketService {
  final SupabaseClient _supabase = Supabase.instance.client;

  int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  String calculateTicketStatus(Map<String, dynamic> ticket) {
    final status = ticket['status']?.toString() ?? 'upcoming';

    if (status == 'disabled') {
      return 'disabled';
    }

    final sold = _parseInt(ticket['sold']);
    final quota = _parseInt(ticket['quota']);

    if (quota > 0 && sold >= quota) {
      return 'sold_out';
    }

    final now = DateTime.now().toUtc();

    final saleStartRaw = ticket['sale_start'];
    final saleEndRaw = ticket['sale_end'];

    final saleStart = saleStartRaw != null
        ? DateTime.tryParse(saleStartRaw.toString())?.toUtc()
        : null;

    final saleEnd = saleEndRaw != null
        ? DateTime.tryParse(saleEndRaw.toString())?.toUtc()
        : null;

    if (saleStart != null && now.isBefore(saleStart)) {
      return 'upcoming';
    }

    if (saleEnd != null && now.isAfter(saleEnd)) {
      return 'ended';
    }

    return 'on_sale';
  }

  Future<List<Map<String, dynamic>>> getTickets(
      String eventId,
      ) async {
    final response = await _supabase
        .from('ticket_types')
        .select()
        .eq('event_id', eventId)
        .order('created_at', ascending: true);

    final tickets = List<Map<String, dynamic>>.from(response);

    return tickets.map((ticket) {
      return {
        ...ticket,
        'calculated_status': calculateTicketStatus(ticket),
      };
    }).toList();
  }

  Future<Map<String, dynamic>> createTicket({
    required String eventId,
    required String name,
    required String description,
    required num price,
    required int quota,
    required int maxPerUser,
    DateTime? saleStart,
    DateTime? saleEnd,
  }) async {
    final response = await _supabase
        .from('ticket_types')
        .insert({
      'event_id': eventId,
      'name': name,
      'description': description,
      'price': price,
      'quota': quota,
      'sold': 0,
      'max_per_user': maxPerUser,
      'sale_start': saleStart?.toIso8601String(),
      'sale_end': saleEnd?.toIso8601String(),
    })
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>?> getTicketById(
      String ticketId,
      ) async {
    final response = await Supabase.instance.client
        .from('ticket_types')
        .select()
        .eq('id', ticketId)
        .maybeSingle();

    return response;
  }

  Future<void> updateTicket({
    required String ticketId,
    required String name,
    required String description,
    required double price,
    required int quota,
    required int maxPerUser,
    required String status,
    required DateTime saleStart,
    required DateTime saleEnd,
  }) async {
    await Supabase.instance.client
        .from('ticket_types')
        .update({
      'name': name,
      'description': description,
      'price': price,
      'quota': quota,
      'max_per_user': maxPerUser,
      'status': status,
      'sale_start': saleStart.toUtc().toIso8601String(),
      'sale_end': saleEnd.toUtc().toIso8601String(),
    })
        .eq('id', ticketId);
  }

  Future<void> deleteTicket(String ticketId) async {
    await Supabase.instance.client
        .from('ticket_types')
        .delete()
        .eq('id', ticketId);
  }
}
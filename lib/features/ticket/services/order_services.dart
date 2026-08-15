import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<String> createOrder({
    required String eventId,
    required List<Map<String, dynamic>> items,
    required num totalAmount,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final orderResponse = await _supabase
        .from('orders')
        .insert({
      'user_id': user.id,
      'event_id': eventId,
      'total_amount': totalAmount,
      'payment_status': 'pending',
    })
        .select('id')
        .single();

    final orderId =
    orderResponse['id'].toString();

    final orderItems = items.map((item) {
      final price = item['price'] as num;
      final quantity = item['quantity'] as int;

      return {
        'order_id': orderId,
        'ticket_type_id': item['ticketId'],
        'quantity': quantity,
        'price': price,
        'subtotal': price * quantity,
      };
    }).toList();

    await _supabase
        .from('order_items')
        .insert(orderItems);

    return orderId;
  }
}
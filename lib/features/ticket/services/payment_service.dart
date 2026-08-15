import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<Map<String, dynamic>> createMidtransPayment({
    required String orderId,
  }) async {
    final response =
    await _supabase.functions.invoke(
      'create-midtrans-payment',
      body: {
        'orderId': orderId,
      },
    );

    final data = response.data;

    if (data == null) {
      throw Exception(
        'Empty response from payment service.',
      );
    }

    if (data['success'] != true) {
      throw Exception(
        data['error'] ??
            'Failed to create Midtrans payment.',
      );
    }

    return Map<String, dynamic>.from(data);
  }

  Future<Map<String, dynamic>> checkPaymentStatus({
    required String orderId,
  }) async {
    final response =
    await _supabase.functions.invoke(
      'check-payment-status',
      body: {
        'orderId': orderId,
      },
    );

    final data = response.data;

    if (data == null) {
      throw Exception(
        'Empty response from payment status service.',
      );
    }

    if (data['success'] != true) {
      throw Exception(
        data['error'] ??
            'Failed to check payment status.',
      );
    }

    return Map<String, dynamic>.from(data);
  }
}
import 'dart:async';
import '../../../app/routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_color.dart';

class PaymentResultPage extends StatefulWidget {
  final String orderId;

  const PaymentResultPage({
    super.key,
    required this.orderId,
  });

  @override
  State<PaymentResultPage> createState() =>
      _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  bool isLoading = true;
  bool isCheckingPayment = false;

  String? errorMessage;

  Map<String, dynamic>? order;

  Timer? _paymentTimer;

  int _checkCount = 0;

  static const int _maxChecks = 30;

  @override
  void initState() {
    super.initState();

    debugPrint(
      'PAYMENT RESULT PAGE OPENED: ${widget.orderId}',
    );

    _loadOrder(
      startPolling: true,
    );
  }

  @override
  void dispose() {
    _paymentTimer?.cancel();

    debugPrint(
      'PAYMENT RESULT PAGE DISPOSED',
    );

    super.dispose();
  }

  Future<void> _loadOrder({
    bool startPolling = false,
  }) async {
    try {
      debugPrint(
        'PAYMENT RESULT: LOAD ORDER ${widget.orderId}',
      );

      final response = await _supabase
          .from('orders')
          .select(
        '''
        id,
        order_number,
        event_id,
        total_amount,
        payment_status,
        payment_method
        ''',
      )
          .eq(
        'id',
        widget.orderId,
      )
          .maybeSingle();

      if (!mounted) return;

      if (response == null) {
        debugPrint(
          'PAYMENT RESULT: ORDER NOT FOUND',
        );

        setState(() {
          isLoading = false;
          errorMessage = 'Order not found.';
        });

        return;
      }

      final loadedOrder =
      Map<String, dynamic>.from(response);

      final status =
      loadedOrder['payment_status']?.toString();

      final paymentMethod =
      loadedOrder['payment_method']?.toString();

      debugPrint(
        'PAYMENT RESULT: '
            'status=$status, '
            'method=$paymentMethod',
      );

      setState(() {
        order = loadedOrder;
        isLoading = false;
        errorMessage = null;
      });

      if (status == 'paid') {
        _paymentTimer?.cancel();

        debugPrint(
          'PAYMENT RESULT: PAYMENT SUCCESSFUL',
        );

        return;
      }

      if (status == 'failed') {
        _paymentTimer?.cancel();

        debugPrint(
          'PAYMENT RESULT: PAYMENT FAILED',
        );

        return;
      }

      if (startPolling && status == 'pending') {
        _startPaymentPolling();
      }
    } catch (e) {
      debugPrint(
        'PAYMENT RESULT LOAD ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _startPaymentPolling() {
    _paymentTimer?.cancel();

    _checkCount = 0;

    debugPrint(
      'PAYMENT RESULT: START POLLING',
    );

    _paymentTimer = Timer.periodic(
      const Duration(seconds: 2),
          (_) async {
        if (!mounted) {
          _paymentTimer?.cancel();
          return;
        }

        if (_checkCount >= _maxChecks) {
          _paymentTimer?.cancel();

          debugPrint(
            'PAYMENT RESULT: '
                'MAX POLLING REACHED',
          );

          if (mounted) {
            setState(() {
              isCheckingPayment = false;
            });
          }

          return;
        }

        _checkCount++;

        debugPrint(
          'PAYMENT RESULT: '
              'CHECK $_checkCount/$_maxChecks',
        );

        await _refreshPaymentStatus();
      },
    );
  }

  Future<void> _refreshPaymentStatus() async {
    if (isCheckingPayment) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isCheckingPayment = true;
    });

    try {
      final response = await _supabase
          .from('orders')
          .select(
        '''
        id,
        order_number,
        event_id,
        total_amount,
        payment_status,
        payment_method
        ''',
      )
          .eq(
        'id',
        widget.orderId,
      )
          .maybeSingle();

      if (!mounted) return;

      if (response == null) {
        _paymentTimer?.cancel();

        setState(() {
          isCheckingPayment = false;
          errorMessage = 'Order not found.';
        });

        return;
      }

      final updatedOrder =
      Map<String, dynamic>.from(response);

      final status =
      updatedOrder['payment_status']?.toString();

      final paymentMethod =
      updatedOrder['payment_method']?.toString();

      debugPrint(
        'PAYMENT RESULT STATUS: '
            '$status | '
            'METHOD: $paymentMethod',
      );

      setState(() {
        order = updatedOrder;
        isCheckingPayment = false;
      });

      if (status == 'paid') {
        _paymentTimer?.cancel();

        debugPrint(
          '========================================',
        );

        debugPrint(
          'PAYMENT RESULT: SUCCESS',
        );

        debugPrint(
          'PAYMENT METHOD: $paymentMethod',
        );

        debugPrint(
          '========================================',
        );

        return;
      }

      if (status == 'failed') {
        _paymentTimer?.cancel();

        debugPrint(
          'PAYMENT RESULT: FAILED',
        );

        return;
      }

      if (status == 'pending') {
        debugPrint(
          'PAYMENT RESULT: STILL PENDING',
        );

        return;
      }
    } catch (e) {
      debugPrint(
        'PAYMENT RESULT REFRESH ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isCheckingPayment = false;
      });
    }
  }

  Future<void> _retryPaymentCheck() async {
    _paymentTimer?.cancel();

    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      isCheckingPayment = false;
    });

    await _loadOrder(
      startPolling: true,
    );
  }

  String formatRupiah(num amount) {
    final str = amount.round().toString();

    final buffer = StringBuffer();

    final reversed =
    str.split('').reversed.toList();

    for (
    int i = 0;
    i < reversed.length;
    i++
    ) {
      buffer.write(reversed[i]);

      if (
      (i + 1) % 3 == 0 &&
          i + 1 != reversed.length
      ) {
        buffer.write('.');
      }
    }

    return 'Rp${buffer.toString().split('').reversed.join()}';
  }

  String paymentMethodLabel(String? method) {
    if (method == null || method.isEmpty) {
      return 'Midtrans';
    }

    switch (method.toLowerCase()) {
      case 'gopay':
        return 'GoPay';

      case 'qris':
        return 'QRIS';

      case 'bank_transfer':
        return 'Bank Transfer';

      case 'bca_va':
        return 'BCA Virtual Account';

      case 'bni_va':
        return 'BNI Virtual Account';

      case 'bri_va':
        return 'BRI Virtual Account';

      case 'echannel':
        return 'Mandiri Bill';

      case 'credit_card':
        return 'Credit Card';

      case 'shopeepay':
        return 'ShopeePay';

      case 'dana':
        return 'DANA';

      case 'ovo':
        return 'OVO';

      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF7F8FA),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xffF7F8FA),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Payment Result',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Unable to load payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _retryPaymentCheck,
                  child: const Text(
                    'Retry',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentOrder = order!;

    final status =
    currentOrder['payment_status']
        ?.toString();

    final paymentMethod =
    currentOrder['payment_method']
        ?.toString();

    final isPaid =
        status == 'paid';

    final isFailed =
        status == 'failed';

    final isPending =
        status == 'pending';

    final total =
        num.tryParse(
          currentOrder['total_amount']
              ?.toString() ??
              '0',
        ) ??
            0;

    return Scaffold(
      backgroundColor:
      const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Payment Result',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 92,
                height: 92,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: isPaid
                      ? Colors.green.withOpacity(0.12)
                      : isFailed
                      ? Colors.red.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.12),
                ),

                child: Icon(
                  isPaid
                      ? Icons.check_circle
                      : isFailed
                      ? Icons.cancel_outlined
                      : Icons.pending_outlined,

                  size: 64,

                  color: isPaid
                      ? Colors.green
                      : isFailed
                      ? Colors.red
                      : Colors.orange,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                isPaid
                    ? 'Payment Successful'
                    : isFailed
                    ? 'Payment Failed'
                    : 'Payment Pending',

                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                isPaid
                    ? 'Your ticket order has been successfully paid.'
                    : isFailed
                    ? 'Your payment could not be completed.'
                    : 'Your payment is still being processed.',

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(16),

                  border: Border.all(
                    color: const Color(0xffE1E3E5),
                  ),
                ),

                child: Column(
                  children: [
                    _ResultRow(
                      label: 'Order',
                      value:
                      currentOrder['order_number']
                          ?.toString() ??
                          '-',
                    ),

                    const SizedBox(height: 14),

                    _ResultRow(
                      label: 'Payment Method',
                      value:
                      paymentMethodLabel(
                        paymentMethod,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _ResultRow(
                      label: 'Status',
                      value:
                      status?.toUpperCase() ??
                          '-',
                    ),

                    const Padding(
                      padding:
                      EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Divider(),
                    ),

                    _ResultRow(
                      label: 'Total',
                      value:
                      formatRupiah(total),
                      bold: true,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              if (isPaid)
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                    },

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColor.primary,

                      foregroundColor:
                      Colors.white,

                      elevation: 0,

                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),

                    child: const Text(
                      'View My Ticket',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              if (isPending)
                Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      if (isCheckingPayment)
                        const SizedBox(
                          width: 16,
                          height: 16,

                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),

                      if (isCheckingPayment)
                        const SizedBox(
                          width: 8,
                        ),

                      Text(
                        isCheckingPayment
                            ? 'Checking payment status...'
                            : 'Waiting for payment confirmation...',
                        style:
                        const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

              if (isFailed)
                Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: const Text(
                    'Please try the payment again.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,

                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.eventpage,
                          (route) => false,
                    );
                  },

                  child: const Text(
                    'Back to Event',
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _ResultRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,

          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),

        Flexible(
          child: Text(
            value,

            textAlign: TextAlign.right,

            style: TextStyle(
              fontSize: 14,

              fontWeight: bold
                  ? FontWeight.w800
                  : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
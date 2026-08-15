import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'payment_result_page.dart';
import 'package:eventra/core/theme/app_color.dart';
import '../services/order_services.dart';
import '../services/payment_service.dart';

class CheckoutPage extends StatefulWidget {
  final String eventId;
  final String eventName;
  final List<CheckoutTicketItem> items;

  const CheckoutPage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.items,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final OrderService _orderService = OrderService();
  final PaymentService _paymentService = PaymentService();

  bool isProcessing = false;

  num get totalPrice {
    return widget.items.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

  int get totalTickets {
    return widget.items.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  String formatRupiah(num amount) {
    final str = amount.round().toString();

    final buffer = StringBuffer();
    final reversed = str.split('').reversed.toList();

    for (int i = 0; i < reversed.length; i++) {
      buffer.write(reversed[i]);

      if ((i + 1) % 3 == 0 &&
          i + 1 != reversed.length) {
        buffer.write('.');
      }
    }

    return 'Rp${buffer.toString().split('').reversed.join()}';
  }

  Future<void> processCheckout() async {
    if (widget.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tickets selected.'),
        ),
      );
      return;
    }

    if (isProcessing) {
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final items = widget.items.map((item) {
        return {
          'ticketId': item.ticketId,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
        };
      }).toList();

      final orderId = await _orderService.createOrder(
        eventId: widget.eventId,
        items: items,
        totalAmount: totalPrice,
      );

      debugPrint('ORDER CREATED: $orderId');

      final payment =
      await _paymentService.createMidtransPayment(
        orderId: orderId,
      );

      debugPrint('MIDTRANS PAYMENT: $payment');

      final redirectUrl =
      payment['redirectUrl']?.toString();

      if (redirectUrl == null ||
          redirectUrl.isEmpty) {
        throw Exception(
          'Midtrans payment URL is missing.',
        );
      }

      debugPrint(
        'MIDTRANS REDIRECT URL: $redirectUrl',
      );

      if (!mounted) {
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MidtransPaymentPage(
            midtransUrl: redirectUrl,
            orderId: orderId,
          ),
        ),
      );

      debugPrint(
        'MIDTRANS PAYMENT PAGE CLOSED',
      );
    } catch (e) {
      debugPrint(
        'CHECKOUT ERROR: $e',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment failed: $e',
          ),
        ),
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          const Text(
            'Event',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            widget.eventName,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Ticket Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xffE1E3E5),
              ),
            ),

            child: Column(
              children: [
                ...widget.items.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),

                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [
                              Container(
                                width: 44,
                                height: 44,

                                decoration: BoxDecoration(
                                  color: AppColor.primary
                                      .withOpacity(0.10),

                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),

                                child: Icon(
                                  Icons
                                      .confirmation_number_outlined,
                                  color: AppColor.primary,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      item.name,

                                      style:
                                      const TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      '${item.quantity} × '
                                          '${formatRupiah(item.price)}',

                                      style:
                                      const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              Text(
                                formatRupiah(item.subtotal),

                                style:
                                const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (index <
                            widget.items.length - 1)
                          const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xffE1E3E5),
              ),
            ),

            child: Column(
              children: [
                _SummaryRow(
                  label: 'Total Tickets',
                  value: '$totalTickets',
                ),

                const SizedBox(height: 12),

                _SummaryRow(
                  label: 'Subtotal',
                  value: formatRupiah(totalPrice),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  child: Divider(
                    height: 1,
                  ),
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Total',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    Text(
                      formatRupiah(totalPrice),

                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Icon(
                  Icons.lock_outline,
                  color: AppColor.primary,
                  size: 21,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    'Your payment will be securely '
                        'processed through our payment gateway.',

                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed:
              isProcessing
                  ? null
                  : processCheckout,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                AppColor.primary,

                foregroundColor:
                Colors.white,

                disabledBackgroundColor:
                AppColor.primary
                    .withOpacity(0.5),

                elevation: 0,

                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              child: isProcessing
                  ? const SizedBox(
                width: 22,
                height: 22,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )

                  : Text(
                'Continue to Payment — '
                    '${formatRupiah(totalPrice)}',

                style:
                const TextStyle(
                  fontSize: 15.5,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MidtransPaymentPage extends StatefulWidget {
  final String midtransUrl;
  final String orderId;

  const MidtransPaymentPage({
    super.key,
    required this.midtransUrl,
    required this.orderId,
  });

  @override
  State<MidtransPaymentPage> createState() =>
      _MidtransPaymentPageState();
}

class _MidtransPaymentPageState
    extends State<MidtransPaymentPage> {

  late final WebViewController _controller;

  Timer? _statusTimer;

  bool isLoading = true;

  bool paymentSuccessful = false;

  bool isCheckingPayment = false;

  bool resultOpening = false;

  String paymentStatus = 'pending';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(

          onPageStarted: (url) {
            debugPrint(
              'WEBVIEW STARTED: $url',
            );

            if (!mounted) {
              return;
            }

            setState(() {
              isLoading = true;
            });
          },

          onPageFinished: (url) {
            debugPrint(
              'WEBVIEW FINISHED: $url',
            );

            if (!mounted) {
              return;
            }

            setState(() {
              isLoading = false;
            });
          },

          onNavigationRequest: (request) {
            debugPrint(
              'WEBVIEW NAVIGATION: '
                  '${request.url}',
            );

            final uri =
            Uri.tryParse(request.url);

            if (uri != null &&
                uri.scheme == 'eventra' &&
                uri.host == 'payment-result') {

              final callbackOrderId =
              uri.queryParameters[
              'order_id'];

              if (callbackOrderId != null &&
                  callbackOrderId.isNotEmpty) {

                debugPrint(
                  'EVENTRA CALLBACK: '
                      '$callbackOrderId',
                );

                _showPaymentResult(
                  callbackOrderId,
                );
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },

          onWebResourceError: (error) {
            debugPrint(
              'WEBVIEW ERROR: '
                  '${error.description}',
            );
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.midtransUrl),
      );

    _startPaymentStatusPolling();
  }

  void _startPaymentStatusPolling() {

    _checkPaymentStatus();

    _statusTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        if (!paymentSuccessful) {
          _checkPaymentStatus();
        }
      },
    );
  }

  Future<void> _checkPaymentStatus() async {

    if (isCheckingPayment ||
        paymentSuccessful) {
      return;
    }

    isCheckingPayment = true;

    try {

      final result =
      await PaymentService()
          .checkPaymentStatus(
        orderId: widget.orderId,
      );

      final status =
      result['status']
          ?.toString()
          .toLowerCase();

      final paid = result['paid'] == true;

      debugPrint(
        'MIDTRANS STATUS: $status',
      );

      debugPrint(
        'MIDTRANS PAID: $paid',
      );

      if (!mounted) {
        return;
      }

      if (status == null) {
        return;
      }

      setState(() {
        paymentStatus = status;
      });

      if (status == 'settlement' ||
          status == 'capture') {

        debugPrint(
          'PAYMENT SUCCESS',
        );

        _markPaymentSuccessful();
      }

    } catch (e) {

      debugPrint(
        'PAYMENT STATUS CHECK ERROR: $e',
      );

    } finally {

      isCheckingPayment = false;
    }
  }

  void _markPaymentSuccessful() {

    if (!mounted ||
        paymentSuccessful) {
      return;
    }

    setState(() {
      paymentSuccessful = true;
      paymentStatus = 'settlement';
    });

    _statusTimer?.cancel();

    debugPrint(
      'CONTINUE BUTTON ENABLED',
    );
  }

  void _showPaymentResult(
      String orderId,
      ) {

    if (!mounted ||
        resultOpening) {
      return;
    }

    resultOpening = true;

    _statusTimer?.cancel();

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentResultPage(
          orderId: orderId,
        ),
      ),
    );
  }

  void _continueToEventra() {

    if (!paymentSuccessful) {
      return;
    }

    _showPaymentResult(
      widget.orderId,
    );
  }

  void _closePayment() {

    _statusTimer?.cancel();

    Navigator.pop(context);
  }

  @override
  void dispose() {

    _statusTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),

          onPressed:
          _closePayment,
        ),

        title: const Text(
          'Payment',

          style: TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: Stack(
        children: [

          WebViewWidget(
            controller:
            _controller,
          ),

          if (isLoading)
            const Center(
              child:
              CircularProgressIndicator(),
            ),
        ],
      ),

      bottomNavigationBar:
      SafeArea(
        child: Container(

          padding:
          const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            12,
          ),

          decoration:
          BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color:
                Colors.black
                    .withOpacity(0.08),

                blurRadius: 10,

                offset:
                const Offset(0, -3),
              ),
            ],
          ),

          child: SizedBox(
            width: double.infinity,

            child: ElevatedButton(

              onPressed:
              paymentSuccessful
                  ? _continueToEventra
                  : null,

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                paymentSuccessful
                    ? AppColor.primary
                    : Colors.grey.shade300,

                foregroundColor:
                paymentSuccessful
                    ? Colors.white
                    : Colors.grey.shade600,

                disabledBackgroundColor:
                Colors.grey.shade300,

                disabledForegroundColor:
                Colors.grey.shade600,

                elevation: 0,

                padding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  if (paymentSuccessful)
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                    ),

                  if (paymentSuccessful)
                    const SizedBox(width: 8),

                  Text(
                    paymentSuccessful
                        ? 'Continue to Eventra'
                        : _paymentStatusText(),

                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _paymentStatusText() {

    switch (paymentStatus) {

      case 'settlement':
      case 'capture':
        return 'Payment Successful';

      case 'pending':
        return 'Waiting for Payment...';

      case 'deny':
      case 'cancel':
      case 'expire':
      case 'failure':
        return 'Payment Unsuccessful';

      default:
        return 'Checking Payment...';
    }
  }
}

class CheckoutTicketItem {

  final String ticketId;
  final String name;
  final num price;
  final int quantity;

  const CheckoutTicketItem({
    required this.ticketId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  num get subtotal {
    return price * quantity;
  }
}

class _SummaryRow
    extends StatelessWidget {

  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(
      BuildContext context) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          label,

          style:
          const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),

        Text(
          value,

          style:
          const TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
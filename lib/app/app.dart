import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import 'routes.dart';

import '../features/ticket/screen/payment_result_page.dart';
import '../features/ticket/services/deep_link_service.dart';

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();

class EventraApp extends StatefulWidget {
  const EventraApp({
    super.key,
  });

  @override
  State<EventraApp> createState() => _EventraAppState();
}

class _EventraAppState extends State<EventraApp> {
  StreamSubscription<Uri>? _deepLinkSubscription;

  bool _isOpeningPaymentResult = false;

  @override
  void initState() {
    super.initState();

    debugPrint('EVENTRA APP: INIT');

    _initializeDeepLinks();
  }

  Future<void> _initializeDeepLinks() async {
    debugPrint(
      'EVENTRA APP: INITIALIZING DEEP LINKS',
    );

    _deepLinkSubscription =
        DeepLinkService.instance.links.listen(
          _handleDeepLink,
          onError: (error) {
            debugPrint(
              'EVENTRA APP: DEEP LINK ERROR: $error',
            );
          },
        );

    await DeepLinkService.instance.initialize();

    debugPrint(
      'EVENTRA APP: DEEP LINKS READY',
    );
  }

  void _handleDeepLink(Uri uri) {
    debugPrint(
      '========================================',
    );

    debugPrint(
      'EVENTRA APP: DEEP LINK RECEIVED',
    );

    debugPrint(
      'URI: $uri',
    );

    debugPrint(
      'SCHEME: ${uri.scheme}',
    );

    debugPrint(
      'HOST: ${uri.host}',
    );

    debugPrint(
      'PATH: ${uri.path}',
    );

    debugPrint(
      'QUERY: ${uri.queryParameters}',
    );

    debugPrint(
      '========================================',
    );

    if (uri.scheme != 'eventra') {
      debugPrint(
        'EVENTRA APP: INVALID SCHEME',
      );

      return;
    }

    if (uri.host != 'payment-result') {
      debugPrint(
        'EVENTRA APP: INVALID HOST',
      );

      return;
    }

    final orderId =
    uri.queryParameters['order_id'];

    if (orderId == null || orderId.isEmpty) {
      debugPrint(
        'EVENTRA APP: ORDER ID MISSING',
      );

      return;
    }

    debugPrint(
      'EVENTRA APP: ORDER ID = $orderId',
    );

    if (_isOpeningPaymentResult) {
      debugPrint(
        'EVENTRA APP: PAYMENT RESULT ALREADY OPEN',
      );

      return;
    }

    final navigator =
        navigatorKey.currentState;

    if (navigator == null) {
      debugPrint(
        'EVENTRA APP: NAVIGATOR NOT READY',
      );

      return;
    }

    _isOpeningPaymentResult = true;

    debugPrint(
      'EVENTRA APP: OPENING PAYMENT RESULT',
    );

    navigator
        .push(
      MaterialPageRoute(
        builder: (_) => PaymentResultPage(
          orderId: orderId,
        ),
      ),
    )
        .whenComplete(() {
      _isOpeningPaymentResult = false;

      debugPrint(
        'EVENTRA APP: PAYMENT RESULT CLOSED',
      );
    });
  }

  @override
  void dispose() {
    debugPrint(
      'EVENTRA APP: DISPOSE',
    );

    _deepLinkSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
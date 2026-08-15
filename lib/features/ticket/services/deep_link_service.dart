import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance =
  DeepLinkService._();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  final StreamController<Uri> _linkController =
  StreamController<Uri>.broadcast();

  Stream<Uri> get links =>
      _linkController.stream;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      debugPrint(
        'DEEP LINK SERVICE: ALREADY INITIALIZED',
      );
      return;
    }

    _initialized = true;

    debugPrint(
      'DEEP LINK SERVICE: INITIALIZING',
    );

    _subscription = _appLinks.uriLinkStream.listen(
          (uri) {
        debugPrint(
          'DEEP LINK RECEIVED: $uri',
        );

        if (!_linkController.isClosed) {
          debugPrint(
            'DEEP LINK EMIT: $uri',
          );

          _linkController.add(uri);
        }
      },
      onError: (error) {
        debugPrint(
          'DEEP LINK STREAM ERROR: $error',
        );
      },
    );

    try {
      final initialUri =
      await _appLinks.getInitialLink();

      if (initialUri != null) {
        debugPrint(
          'INITIAL DEEP LINK: $initialUri',
        );

        if (!_linkController.isClosed) {
          _linkController.add(initialUri);
        }
      }
    } catch (e) {
      debugPrint(
        'INITIAL DEEP LINK ERROR: $e',
      );
    }
  }

  Future<void> dispose() async {
    debugPrint(
      'DEEP LINK SERVICE: DISPOSE',
    );

    await _subscription?.cancel();

    _subscription = null;

    _initialized = false;

    if (!_linkController.isClosed) {
      await _linkController.close();
    }
  }
}
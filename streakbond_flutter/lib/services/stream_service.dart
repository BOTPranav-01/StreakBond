import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:streakbond_client/streakbond_client.dart';
import '../client.dart';

/// Service managing real-time event updates from Serverpod.
/// Subscribes to StreakStreamEndpoint and broadcasts PactEvents across the app.
class StreamService {
  StreamService._internal();
  static final StreamService instance = StreamService._internal();

  StreamSubscription<PactEvent>? _subscription;
  final _eventController = StreamController<PactEvent>.broadcast();

  /// Stream of all incoming real-time pact events.
  Stream<PactEvent> get events => _eventController.stream;

  bool _isListening = false;
  bool get isListening => _isListening;

  /// Starts listening for real-time updates for the authenticated user.
  Future<void> startListening() async {
    if (_isListening) return;

    try {
      final stream = client.streakStream.listenForUpdates();
      _isListening = true;
      _subscription = stream.listen(
        (event) {
          debugPrint(
            'StreamService received event: ${event.eventType} for pact: ${event.pactId}',
          );
          _eventController.add(event);
        },
        onError: (error) {
          debugPrint('StreamService error: $error');
          _isListening = false;
          _reconnect();
        },
        onDone: () {
          debugPrint('StreamService closed');
          _isListening = false;
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('Failed to start StreamService: $e');
      _isListening = false;
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isListening) {
        startListening();
      }
    });
  }

  /// Stops listening and cancels subscription.
  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _isListening = false;
  }

  void dispose() {
    stopListening();
    _eventController.close();
  }
}

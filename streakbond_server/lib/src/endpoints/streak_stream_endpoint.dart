import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Streaming endpoint for real-time pact event updates.
/// Clients connect via WebSocket and receive PactEvent messages
/// when their partner checks in or when streaks change.
class StreakStreamEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Opens a persistent stream of PactEvent messages for the
  /// authenticated user. Events are broadcast via session.messages
  /// from the PactEndpoint and StreakEvaluator.
  Stream<PactEvent> listenForUpdates(Session session) async* {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) {
      return;
    }

    final channel = 'user_$userId';
    final messageStream = session.messages.createStream<PactEvent>(channel);
    await for (final event in messageStream) {
      yield event;
    }
  }
}

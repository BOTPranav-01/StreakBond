/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Real-time event broadcast to connected clients.
abstract class PactEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PactEvent._({
    required this.pactId,
    required this.eventType,
    required this.streak,
    required this.message,
  });

  factory PactEvent({
    required int pactId,
    required String eventType,
    required int streak,
    required String message,
  }) = _PactEventImpl;

  factory PactEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PactEvent(
      pactId: jsonSerialization['pactId'] as int,
      eventType: jsonSerialization['eventType'] as String,
      streak: jsonSerialization['streak'] as int,
      message: jsonSerialization['message'] as String,
    );
  }

  /// The pact this event relates to.
  int pactId;

  /// Event type: 'streakUp', 'streakLost', 'partnerCheckedIn', 'pactAccepted'.
  String eventType;

  /// Current streak value after this event.
  int streak;

  /// Human-readable event message.
  String message;

  /// Returns a shallow copy of this [PactEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PactEvent copyWith({
    int? pactId,
    String? eventType,
    int? streak,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PactEvent',
      'pactId': pactId,
      'eventType': eventType,
      'streak': streak,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PactEvent',
      'pactId': pactId,
      'eventType': eventType,
      'streak': streak,
      'message': message,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PactEventImpl extends PactEvent {
  _PactEventImpl({
    required int pactId,
    required String eventType,
    required int streak,
    required String message,
  }) : super._(
         pactId: pactId,
         eventType: eventType,
         streak: streak,
         message: message,
       );

  /// Returns a shallow copy of this [PactEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PactEvent copyWith({
    int? pactId,
    String? eventType,
    int? streak,
    String? message,
  }) {
    return PactEvent(
      pactId: pactId ?? this.pactId,
      eventType: eventType ?? this.eventType,
      streak: streak ?? this.streak,
      message: message ?? this.message,
    );
  }
}

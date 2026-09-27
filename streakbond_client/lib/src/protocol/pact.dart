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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'pact_status.dart' as _irjbousi;

/// A two-person accountability pact with a shared daily commitment.
abstract class Pact
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Pact._({
    this.id,
    required this.title,
    required this.ownerId,
    this.partnerId,
    required this.inviteCode,
    required this.status,
    required this.streak,
    required this.bestStreak,
    required this.checkInWindowStartUtc,
    required this.checkInWindowEndUtc,
    required this.createdAt,
  });

  factory Pact({
    int? id,
    required String title,
    required String ownerId,
    String? partnerId,
    required String inviteCode,
    required _irjbousi.PactStatus status,
    required int streak,
    required int bestStreak,
    required String checkInWindowStartUtc,
    required String checkInWindowEndUtc,
    required DateTime createdAt,
  }) = _PactImpl;

  factory Pact.fromJson(Map<String, dynamic> jsonSerialization) {
    return Pact(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      ownerId: jsonSerialization['ownerId'] as String,
      partnerId: jsonSerialization['partnerId'] as String?,
      inviteCode: jsonSerialization['inviteCode'] as String,
      status: _irjbousi.PactStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      streak: jsonSerialization['streak'] as int,
      bestStreak: jsonSerialization['bestStreak'] as int,
      checkInWindowStartUtc:
          jsonSerialization['checkInWindowStartUtc'] as String,
      checkInWindowEndUtc: jsonSerialization['checkInWindowEndUtc'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The title of the daily commitment (e.g., '20 pushups').
  String title;

  /// The user identifier of the pact creator.
  String ownerId;

  /// The user identifier of the partner (null until accepted).
  String? partnerId;

  /// Short invite code for partner to join (e.g., 'BOND-7X3K').
  String inviteCode;

  /// Current status: pending, active, or broken.
  _irjbousi.PactStatus status;

  /// Current consecutive streak count.
  int streak;

  /// All-time best streak for this pact.
  int bestStreak;

  /// Check-in window start time in UTC, format 'HH:mm'.
  String checkInWindowStartUtc;

  /// Check-in window end time in UTC, format 'HH:mm'.
  String checkInWindowEndUtc;

  /// When this pact was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [Pact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Pact copyWith({
    int? id,
    String? title,
    String? ownerId,
    String? partnerId,
    String? inviteCode,
    _irjbousi.PactStatus? status,
    int? streak,
    int? bestStreak,
    String? checkInWindowStartUtc,
    String? checkInWindowEndUtc,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Pact',
      if (id != null) 'id': id,
      'title': title,
      'ownerId': ownerId,
      if (partnerId != null) 'partnerId': partnerId,
      'inviteCode': inviteCode,
      'status': status.toJson(),
      'streak': streak,
      'bestStreak': bestStreak,
      'checkInWindowStartUtc': checkInWindowStartUtc,
      'checkInWindowEndUtc': checkInWindowEndUtc,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Pact',
      if (id != null) 'id': id,
      'title': title,
      'ownerId': ownerId,
      if (partnerId != null) 'partnerId': partnerId,
      'inviteCode': inviteCode,
      'status': status.toJson(),
      'streak': streak,
      'bestStreak': bestStreak,
      'checkInWindowStartUtc': checkInWindowStartUtc,
      'checkInWindowEndUtc': checkInWindowEndUtc,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PactImpl extends Pact {
  _PactImpl({
    int? id,
    required String title,
    required String ownerId,
    String? partnerId,
    required String inviteCode,
    required _irjbousi.PactStatus status,
    required int streak,
    required int bestStreak,
    required String checkInWindowStartUtc,
    required String checkInWindowEndUtc,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         ownerId: ownerId,
         partnerId: partnerId,
         inviteCode: inviteCode,
         status: status,
         streak: streak,
         bestStreak: bestStreak,
         checkInWindowStartUtc: checkInWindowStartUtc,
         checkInWindowEndUtc: checkInWindowEndUtc,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Pact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Pact copyWith({
    Object? id = _Undefined,
    String? title,
    String? ownerId,
    Object? partnerId = _Undefined,
    String? inviteCode,
    _irjbousi.PactStatus? status,
    int? streak,
    int? bestStreak,
    String? checkInWindowStartUtc,
    String? checkInWindowEndUtc,
    DateTime? createdAt,
  }) {
    return Pact(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      ownerId: ownerId ?? this.ownerId,
      partnerId: partnerId is String? ? partnerId : this.partnerId,
      inviteCode: inviteCode ?? this.inviteCode,
      status: status ?? this.status,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      checkInWindowStartUtc:
          checkInWindowStartUtc ?? this.checkInWindowStartUtc,
      checkInWindowEndUtc: checkInWindowEndUtc ?? this.checkInWindowEndUtc,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

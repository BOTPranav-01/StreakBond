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

/// A single daily check-in record. One per user per pact per day.
abstract class CheckIn
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CheckIn._({
    this.id,
    required this.pactId,
    required this.userId,
    required this.day,
    required this.createdAt,
  });

  factory CheckIn({
    int? id,
    required int pactId,
    required String userId,
    required String day,
    required DateTime createdAt,
  }) = _CheckInImpl;

  factory CheckIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckIn(
      id: jsonSerialization['id'] as int?,
      pactId: jsonSerialization['pactId'] as int,
      userId: jsonSerialization['userId'] as String,
      day: jsonSerialization['day'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The pact this check-in belongs to.
  int pactId;

  /// The user identifier who checked in.
  String userId;

  /// The date of check-in in 'yyyy-MM-dd' format (UTC).
  String day;

  /// When this check-in was recorded.
  DateTime createdAt;

  /// Returns a shallow copy of this [CheckIn]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CheckIn copyWith({
    int? id,
    int? pactId,
    String? userId,
    String? day,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckIn',
      if (id != null) 'id': id,
      'pactId': pactId,
      'userId': userId,
      'day': day,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CheckIn',
      if (id != null) 'id': id,
      'pactId': pactId,
      'userId': userId,
      'day': day,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckInImpl extends CheckIn {
  _CheckInImpl({
    int? id,
    required int pactId,
    required String userId,
    required String day,
    required DateTime createdAt,
  }) : super._(
         id: id,
         pactId: pactId,
         userId: userId,
         day: day,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CheckIn]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CheckIn copyWith({
    Object? id = _Undefined,
    int? pactId,
    String? userId,
    String? day,
    DateTime? createdAt,
  }) {
    return CheckIn(
      id: id is int? ? id : this.id,
      pactId: pactId ?? this.pactId,
      userId: userId ?? this.userId,
      day: day ?? this.day,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

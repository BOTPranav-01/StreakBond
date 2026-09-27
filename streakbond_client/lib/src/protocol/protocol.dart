/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:streakbond_client/src/protocol/check_in.dart' as _ih1k4fw8;
import 'package:streakbond_client/src/protocol/pact.dart' as _i8tmqtse;
import 'check_in.dart' as _if7ha0eo;
import 'pact.dart' as _icyj8wi1;
import 'pact_event.dart' as _iesh8xmc;
import 'pact_status.dart' as _irjbousi;
export 'check_in.dart';
export 'pact.dart';
export 'pact_event.dart';
export 'pact_status.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _if7ha0eo.CheckIn) {
      return _if7ha0eo.CheckIn.fromJson(data) as T;
    }
    if (t == _icyj8wi1.Pact) {
      return _icyj8wi1.Pact.fromJson(data) as T;
    }
    if (t == _iesh8xmc.PactEvent) {
      return _iesh8xmc.PactEvent.fromJson(data) as T;
    }
    if (t == _irjbousi.PactStatus) {
      return _irjbousi.PactStatus.fromJson(data) as T;
    }
    if (t == _isc.getType<_if7ha0eo.CheckIn?>()) {
      return (data != null ? _if7ha0eo.CheckIn.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icyj8wi1.Pact?>()) {
      return (data != null ? _icyj8wi1.Pact.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iesh8xmc.PactEvent?>()) {
      return (data != null ? _iesh8xmc.PactEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irjbousi.PactStatus?>()) {
      return (data != null ? _irjbousi.PactStatus.fromJson(data) : null) as T;
    }
    if (t == List<_i8tmqtse.Pact>) {
      return (data as List).map((e) => deserialize<_i8tmqtse.Pact>(e)).toList()
          as T;
    }
    if (t == List<_ih1k4fw8.CheckIn>) {
      return (data as List)
              .map((e) => deserialize<_ih1k4fw8.CheckIn>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _if7ha0eo.CheckIn => 'CheckIn',
      _icyj8wi1.Pact => 'Pact',
      _iesh8xmc.PactEvent => 'PactEvent',
      _irjbousi.PactStatus => 'PactStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('streakbond.', '');
    }

    switch (data) {
      case _if7ha0eo.CheckIn():
        return 'CheckIn';
      case _icyj8wi1.Pact():
        return 'Pact';
      case _iesh8xmc.PactEvent():
        return 'PactEvent';
      case _irjbousi.PactStatus():
        return 'PactStatus';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CheckIn') {
      return deserialize<_if7ha0eo.CheckIn>(data['data']);
    }
    if (dataClassName == 'Pact') {
      return deserialize<_icyj8wi1.Pact>(data['data']);
    }
    if (dataClassName == 'PactEvent') {
      return deserialize<_iesh8xmc.PactEvent>(data['data']);
    }
    if (dataClassName == 'PactStatus') {
      return deserialize<_irjbousi.PactStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('streakbond', this);
    _iacc.Protocol().registerHostProtocol('streakbond', this);
  }

  @override
  String getModuleName() => 'streakbond';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

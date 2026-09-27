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
import 'pact_status.dart' as _irjbousi;

/// A two-person accountability pact with a shared daily commitment.
abstract class Pact implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PactTable();

  static const db = PactRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Pact]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static PactInclude include() {
    return PactInclude._();
  }

  static PactIncludeList includeList({
    _is.WhereExpressionBuilder<PactTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PactTable>? orderBy,
    _is.OrderByListBuilder<PactTable>? orderByList,
    PactInclude? include,
  }) {
    return PactIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Pact.t),
      orderByList: orderByList?.call(Pact.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class PactUpdateTable extends _is.UpdateTable<PactTable> {
  PactUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> ownerId(String value) => _is.ColumnValue(
    table.ownerId,
    value,
  );

  _is.ColumnValue<String, String> partnerId(String? value) => _is.ColumnValue(
    table.partnerId,
    value,
  );

  _is.ColumnValue<String, String> inviteCode(String value) => _is.ColumnValue(
    table.inviteCode,
    value,
  );

  _is.ColumnValue<_irjbousi.PactStatus, _irjbousi.PactStatus> status(
    _irjbousi.PactStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> streak(int value) => _is.ColumnValue(
    table.streak,
    value,
  );

  _is.ColumnValue<int, int> bestStreak(int value) => _is.ColumnValue(
    table.bestStreak,
    value,
  );

  _is.ColumnValue<String, String> checkInWindowStartUtc(String value) =>
      _is.ColumnValue(
        table.checkInWindowStartUtc,
        value,
      );

  _is.ColumnValue<String, String> checkInWindowEndUtc(String value) =>
      _is.ColumnValue(
        table.checkInWindowEndUtc,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PactTable extends _is.Table<int?> {
  PactTable({super.tableRelation}) : super(tableName: 'pact') {
    updateTable = PactUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    ownerId = _is.ColumnString(
      'ownerId',
      this,
    );
    partnerId = _is.ColumnString(
      'partnerId',
      this,
    );
    inviteCode = _is.ColumnString(
      'inviteCode',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    streak = _is.ColumnInt(
      'streak',
      this,
    );
    bestStreak = _is.ColumnInt(
      'bestStreak',
      this,
    );
    checkInWindowStartUtc = _is.ColumnString(
      'checkInWindowStartUtc',
      this,
    );
    checkInWindowEndUtc = _is.ColumnString(
      'checkInWindowEndUtc',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PactUpdateTable updateTable;

  /// The title of the daily commitment (e.g., '20 pushups').
  late final _is.ColumnString title;

  /// The user identifier of the pact creator.
  late final _is.ColumnString ownerId;

  /// The user identifier of the partner (null until accepted).
  late final _is.ColumnString partnerId;

  /// Short invite code for partner to join (e.g., 'BOND-7X3K').
  late final _is.ColumnString inviteCode;

  /// Current status: pending, active, or broken.
  late final _is.ColumnEnum<_irjbousi.PactStatus> status;

  /// Current consecutive streak count.
  late final _is.ColumnInt streak;

  /// All-time best streak for this pact.
  late final _is.ColumnInt bestStreak;

  /// Check-in window start time in UTC, format 'HH:mm'.
  late final _is.ColumnString checkInWindowStartUtc;

  /// Check-in window end time in UTC, format 'HH:mm'.
  late final _is.ColumnString checkInWindowEndUtc;

  /// When this pact was created.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    title,
    ownerId,
    partnerId,
    inviteCode,
    status,
    streak,
    bestStreak,
    checkInWindowStartUtc,
    checkInWindowEndUtc,
    createdAt,
  ];
}

class PactInclude extends _is.IncludeObject {
  PactInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Pact.t;
}

class PactIncludeList extends _is.IncludeList {
  PactIncludeList._({
    _is.WhereExpressionBuilder<PactTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Pact.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Pact.t;
}

class PactRepository {
  const PactRepository._();

  /// Returns a list of [Pact]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Pact>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PactTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PactTable>? orderBy,
    _is.OrderByListBuilder<PactTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Pact>(
      where: where?.call(Pact.t),
      orderBy: orderBy?.call(Pact.t),
      orderByList: orderByList?.call(Pact.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Pact] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Pact?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PactTable>? where,
    int? offset,
    _is.OrderByBuilder<PactTable>? orderBy,
    _is.OrderByListBuilder<PactTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Pact>(
      where: where?.call(Pact.t),
      orderBy: orderBy?.call(Pact.t),
      orderByList: orderByList?.call(Pact.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Pact] by its [id] or null if no such row exists.
  Future<Pact?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Pact>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Pact]s in the list and returns the inserted rows.
  ///
  /// The returned [Pact]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pact>> insert(
    _is.DatabaseSession session,
    List<Pact> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Pact>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Pact] and returns the inserted row.
  ///
  /// The returned [Pact] will have its `id` field set.
  Future<Pact> insertRow(
    _is.DatabaseSession session,
    Pact row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Pact>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Pact]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Pact]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pact>> upsert(
    _is.DatabaseSession session,
    List<Pact> rows, {
    required _is.ColumnSelections<PactTable> conflictColumns,
    _is.ColumnSelections<PactTable>? updateColumns,
    _is.WhereExpressionBuilder<PactTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Pact>(
      rows,
      conflictColumns: conflictColumns(Pact.t),
      updateColumns: updateColumns?.call(Pact.t),
      updateWhere: updateWhere?.call(Pact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Pact] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Pact] will have its `id` field set.
  Future<Pact?> upsertRow(
    _is.DatabaseSession session,
    Pact row, {
    required _is.ColumnSelections<PactTable> conflictColumns,
    _is.ColumnSelections<PactTable>? updateColumns,
    _is.WhereExpressionBuilder<PactTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Pact>(
      row,
      conflictColumns: conflictColumns(Pact.t),
      updateColumns: updateColumns?.call(Pact.t),
      updateWhere: updateWhere?.call(Pact.t),
      transaction: transaction,
    );
  }

  /// Updates all [Pact]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pact>> update(
    _is.DatabaseSession session,
    List<Pact> rows, {
    _is.ColumnSelections<PactTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Pact>(
      rows,
      columns: columns?.call(Pact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Pact]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Pact> updateRow(
    _is.DatabaseSession session,
    Pact row, {
    _is.ColumnSelections<PactTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Pact>(
      row,
      columns: columns?.call(Pact.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Pact] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Pact?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PactUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Pact>(
      id,
      columnValues: columnValues(Pact.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Pact]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pact>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PactUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PactTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PactTable>? orderBy,
    _is.OrderByListBuilder<PactTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Pact>(
      columnValues: columnValues(Pact.t.updateTable),
      where: where(Pact.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Pact.t),
      orderByList: orderByList?.call(Pact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Pact]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pact>> delete(
    _is.DatabaseSession session,
    List<Pact> rows, {
    _is.OrderByBuilder<PactTable>? orderBy,
    _is.OrderByListBuilder<PactTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Pact>(
      rows,
      orderBy: orderBy?.call(Pact.t),
      orderByList: orderByList?.call(Pact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Pact].
  Future<Pact> deleteRow(
    _is.DatabaseSession session,
    Pact row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Pact>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pact>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PactTable> where,
    _is.OrderByBuilder<PactTable>? orderBy,
    _is.OrderByListBuilder<PactTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Pact>(
      where: where(Pact.t),
      orderBy: orderBy?.call(Pact.t),
      orderByList: orderByList?.call(Pact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PactTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Pact>(
      where: where?.call(Pact.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Pact] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PactTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Pact>(
      where: where(Pact.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

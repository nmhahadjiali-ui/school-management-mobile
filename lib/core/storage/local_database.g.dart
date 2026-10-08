// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $MetaEntriesTable extends MetaEntries
    with TableInfo<$MetaEntriesTable, MetaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MetaEntriesTable createAlias(String alias) {
    return $MetaEntriesTable(attachedDatabase, alias);
  }
}

class MetaEntry extends DataClass implements Insertable<MetaEntry> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const MetaEntry({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MetaEntriesCompanion toCompanion(bool nullToAbsent) {
    return MetaEntriesCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory MetaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MetaEntry copyWith({String? key, String? value, DateTime? updatedAt}) =>
      MetaEntry(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MetaEntry copyWithCompanion(MetaEntriesCompanion data) {
    return MetaEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntry(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaEntry &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class MetaEntriesCompanion extends UpdateCompanion<MetaEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MetaEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaEntriesCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MetaEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedNotificationsTable extends CachedNotifications
    with TableInfo<$CachedNotificationsTable, CachedNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    message,
    data,
    priority,
    createdAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $CachedNotificationsTable createAlias(String alias) {
    return $CachedNotificationsTable(attachedDatabase, alias);
  }
}

class CachedNotification extends DataClass
    implements Insertable<CachedNotification> {
  final String id;
  final String type;
  final String title;
  final String message;
  final String data;
  final String priority;
  final DateTime createdAt;
  final DateTime? readAt;
  const CachedNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.priority,
    required this.createdAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['message'] = Variable<String>(message);
    map['data'] = Variable<String>(data);
    map['priority'] = Variable<String>(priority);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  CachedNotificationsCompanion toCompanion(bool nullToAbsent) {
    return CachedNotificationsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      message: Value(message),
      data: Value(data),
      priority: Value(priority),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory CachedNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedNotification(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String>(json['message']),
      data: serializer.fromJson<String>(json['data']),
      priority: serializer.fromJson<String>(json['priority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String>(message),
      'data': serializer.toJson<String>(data),
      'priority': serializer.toJson<String>(priority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  CachedNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? data,
    String? priority,
    DateTime? createdAt,
    Value<DateTime?> readAt = const Value.absent(),
  }) => CachedNotification(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    message: message ?? this.message,
    data: data ?? this.data,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  CachedNotification copyWithCompanion(CachedNotificationsCompanion data) {
    return CachedNotification(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      data: data.data.present ? data.data.value : this.data,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedNotification(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('data: $data, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, title, message, data, priority, createdAt, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedNotification &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.message == this.message &&
          other.data == this.data &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class CachedNotificationsCompanion extends UpdateCompanion<CachedNotification> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String> message;
  final Value<String> data;
  final Value<String> priority;
  final Value<DateTime> createdAt;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const CachedNotificationsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.data = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedNotificationsCompanion.insert({
    required String id,
    required String type,
    required String title,
    required String message,
    this.data = const Value.absent(),
    this.priority = const Value.absent(),
    required DateTime createdAt,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       message = Value(message),
       createdAt = Value(createdAt);
  static Insertable<CachedNotification> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? message,
    Expression<String>? data,
    Expression<String>? priority,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (data != null) 'data': data,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String>? message,
    Value<String>? data,
    Value<String>? priority,
    Value<DateTime>? createdAt,
    Value<DateTime?>? readAt,
    Value<int>? rowid,
  }) {
    return CachedNotificationsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('data: $data, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAnnouncementsTable extends CachedAnnouncements
    with TableInfo<$CachedAnnouncementsTable, CachedAnnouncement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAnnouncementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    priority,
    publishedAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_announcements';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAnnouncement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAnnouncement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAnnouncement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $CachedAnnouncementsTable createAlias(String alias) {
    return $CachedAnnouncementsTable(attachedDatabase, alias);
  }
}

class CachedAnnouncement extends DataClass
    implements Insertable<CachedAnnouncement> {
  final String id;
  final String title;
  final String content;
  final String priority;
  final DateTime? publishedAt;
  final DateTime? expiresAt;
  const CachedAnnouncement({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    this.publishedAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  CachedAnnouncementsCompanion toCompanion(bool nullToAbsent) {
    return CachedAnnouncementsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      priority: Value(priority),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory CachedAnnouncement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAnnouncement(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      priority: serializer.fromJson<String>(json['priority']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'priority': serializer.toJson<String>(priority),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  CachedAnnouncement copyWith({
    String? id,
    String? title,
    String? content,
    String? priority,
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => CachedAnnouncement(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    priority: priority ?? this.priority,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  CachedAnnouncement copyWithCompanion(CachedAnnouncementsCompanion data) {
    return CachedAnnouncement(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      priority: data.priority.present ? data.priority.value : this.priority,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAnnouncement(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('priority: $priority, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, priority, publishedAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAnnouncement &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.priority == this.priority &&
          other.publishedAt == this.publishedAt &&
          other.expiresAt == this.expiresAt);
}

class CachedAnnouncementsCompanion extends UpdateCompanion<CachedAnnouncement> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> priority;
  final Value<DateTime?> publishedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const CachedAnnouncementsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.priority = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAnnouncementsCompanion.insert({
    required String id,
    required String title,
    required String content,
    required String priority,
    this.publishedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       priority = Value(priority);
  static Insertable<CachedAnnouncement> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? priority,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (priority != null) 'priority': priority,
      if (publishedAt != null) 'published_at': publishedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAnnouncementsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<String>? priority,
    Value<DateTime?>? publishedAt,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return CachedAnnouncementsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      publishedAt: publishedAt ?? this.publishedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAnnouncementsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('priority: $priority, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSectionsTable extends CachedSections
    with TableInfo<$CachedSectionsTable, CachedSection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeLevelMeta = const VerificationMeta(
    'gradeLevel',
  );
  @override
  late final GeneratedColumn<String> gradeLevel = GeneratedColumn<String>(
    'grade_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _academicYearIdMeta = const VerificationMeta(
    'academicYearId',
  );
  @override
  late final GeneratedColumn<String> academicYearId = GeneratedColumn<String>(
    'academic_year_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, gradeLevel, academicYearId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('grade_level')) {
      context.handle(
        _gradeLevelMeta,
        gradeLevel.isAcceptableOrUnknown(data['grade_level']!, _gradeLevelMeta),
      );
    }
    if (data.containsKey('academic_year_id')) {
      context.handle(
        _academicYearIdMeta,
        academicYearId.isAcceptableOrUnknown(
          data['academic_year_id']!,
          _academicYearIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicYearIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gradeLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade_level'],
      )!,
      academicYearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year_id'],
      )!,
    );
  }

  @override
  $CachedSectionsTable createAlias(String alias) {
    return $CachedSectionsTable(attachedDatabase, alias);
  }
}

class CachedSection extends DataClass implements Insertable<CachedSection> {
  final String id;
  final String name;
  final String gradeLevel;
  final String academicYearId;
  const CachedSection({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.academicYearId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['grade_level'] = Variable<String>(gradeLevel);
    map['academic_year_id'] = Variable<String>(academicYearId);
    return map;
  }

  CachedSectionsCompanion toCompanion(bool nullToAbsent) {
    return CachedSectionsCompanion(
      id: Value(id),
      name: Value(name),
      gradeLevel: Value(gradeLevel),
      academicYearId: Value(academicYearId),
    );
  }

  factory CachedSection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSection(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gradeLevel: serializer.fromJson<String>(json['gradeLevel']),
      academicYearId: serializer.fromJson<String>(json['academicYearId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'gradeLevel': serializer.toJson<String>(gradeLevel),
      'academicYearId': serializer.toJson<String>(academicYearId),
    };
  }

  CachedSection copyWith({
    String? id,
    String? name,
    String? gradeLevel,
    String? academicYearId,
  }) => CachedSection(
    id: id ?? this.id,
    name: name ?? this.name,
    gradeLevel: gradeLevel ?? this.gradeLevel,
    academicYearId: academicYearId ?? this.academicYearId,
  );
  CachedSection copyWithCompanion(CachedSectionsCompanion data) {
    return CachedSection(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gradeLevel: data.gradeLevel.present
          ? data.gradeLevel.value
          : this.gradeLevel,
      academicYearId: data.academicYearId.present
          ? data.academicYearId.value
          : this.academicYearId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSection(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gradeLevel: $gradeLevel, ')
          ..write('academicYearId: $academicYearId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, gradeLevel, academicYearId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSection &&
          other.id == this.id &&
          other.name == this.name &&
          other.gradeLevel == this.gradeLevel &&
          other.academicYearId == this.academicYearId);
}

class CachedSectionsCompanion extends UpdateCompanion<CachedSection> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> gradeLevel;
  final Value<String> academicYearId;
  final Value<int> rowid;
  const CachedSectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gradeLevel = const Value.absent(),
    this.academicYearId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSectionsCompanion.insert({
    required String id,
    required String name,
    this.gradeLevel = const Value.absent(),
    required String academicYearId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       academicYearId = Value(academicYearId);
  static Insertable<CachedSection> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? gradeLevel,
    Expression<String>? academicYearId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gradeLevel != null) 'grade_level': gradeLevel,
      if (academicYearId != null) 'academic_year_id': academicYearId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? gradeLevel,
    Value<String>? academicYearId,
    Value<int>? rowid,
  }) {
    return CachedSectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      academicYearId: academicYearId ?? this.academicYearId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gradeLevel.present) {
      map['grade_level'] = Variable<String>(gradeLevel.value);
    }
    if (academicYearId.present) {
      map['academic_year_id'] = Variable<String>(academicYearId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gradeLevel: $gradeLevel, ')
          ..write('academicYearId: $academicYearId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedStudentsTable extends CachedStudents
    with TableInfo<$CachedStudentsTable, CachedStudent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedStudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentNumberMeta = const VerificationMeta(
    'studentNumber',
  );
  @override
  late final GeneratedColumn<String> studentNumber = GeneratedColumn<String>(
    'student_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentNumber,
    firstName,
    lastName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_students';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedStudent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_number')) {
      context.handle(
        _studentNumberMeta,
        studentNumber.isAcceptableOrUnknown(
          data['student_number']!,
          _studentNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_studentNumberMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedStudent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedStudent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_number'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
    );
  }

  @override
  $CachedStudentsTable createAlias(String alias) {
    return $CachedStudentsTable(attachedDatabase, alias);
  }
}

class CachedStudent extends DataClass implements Insertable<CachedStudent> {
  final String id;
  final String studentNumber;
  final String firstName;
  final String lastName;
  const CachedStudent({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_number'] = Variable<String>(studentNumber);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    return map;
  }

  CachedStudentsCompanion toCompanion(bool nullToAbsent) {
    return CachedStudentsCompanion(
      id: Value(id),
      studentNumber: Value(studentNumber),
      firstName: Value(firstName),
      lastName: Value(lastName),
    );
  }

  factory CachedStudent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedStudent(
      id: serializer.fromJson<String>(json['id']),
      studentNumber: serializer.fromJson<String>(json['studentNumber']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentNumber': serializer.toJson<String>(studentNumber),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
    };
  }

  CachedStudent copyWith({
    String? id,
    String? studentNumber,
    String? firstName,
    String? lastName,
  }) => CachedStudent(
    id: id ?? this.id,
    studentNumber: studentNumber ?? this.studentNumber,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
  );
  CachedStudent copyWithCompanion(CachedStudentsCompanion data) {
    return CachedStudent(
      id: data.id.present ? data.id.value : this.id,
      studentNumber: data.studentNumber.present
          ? data.studentNumber.value
          : this.studentNumber,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedStudent(')
          ..write('id: $id, ')
          ..write('studentNumber: $studentNumber, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentNumber, firstName, lastName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedStudent &&
          other.id == this.id &&
          other.studentNumber == this.studentNumber &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName);
}

class CachedStudentsCompanion extends UpdateCompanion<CachedStudent> {
  final Value<String> id;
  final Value<String> studentNumber;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<int> rowid;
  const CachedStudentsCompanion({
    this.id = const Value.absent(),
    this.studentNumber = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedStudentsCompanion.insert({
    required String id,
    required String studentNumber,
    required String firstName,
    required String lastName,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentNumber = Value(studentNumber),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<CachedStudent> custom({
    Expression<String>? id,
    Expression<String>? studentNumber,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentNumber != null) 'student_number': studentNumber,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedStudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentNumber,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<int>? rowid,
  }) {
    return CachedStudentsCompanion(
      id: id ?? this.id,
      studentNumber: studentNumber ?? this.studentNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentNumber.present) {
      map['student_number'] = Variable<String>(studentNumber.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedStudentsCompanion(')
          ..write('id: $id, ')
          ..write('studentNumber: $studentNumber, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedEnrollmentsTable extends CachedEnrollments
    with TableInfo<$CachedEnrollmentsTable, CachedEnrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedEnrollmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _academicYearIdMeta = const VerificationMeta(
    'academicYearId',
  );
  @override
  late final GeneratedColumn<String> academicYearId = GeneratedColumn<String>(
    'academic_year_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    sectionId,
    academicYearId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_enrollments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedEnrollment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('academic_year_id')) {
      context.handle(
        _academicYearIdMeta,
        academicYearId.isAcceptableOrUnknown(
          data['academic_year_id']!,
          _academicYearIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicYearIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedEnrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedEnrollment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      academicYearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year_id'],
      )!,
    );
  }

  @override
  $CachedEnrollmentsTable createAlias(String alias) {
    return $CachedEnrollmentsTable(attachedDatabase, alias);
  }
}

class CachedEnrollment extends DataClass
    implements Insertable<CachedEnrollment> {
  final String id;
  final String studentId;
  final String sectionId;
  final String academicYearId;
  const CachedEnrollment({
    required this.id,
    required this.studentId,
    required this.sectionId,
    required this.academicYearId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['section_id'] = Variable<String>(sectionId);
    map['academic_year_id'] = Variable<String>(academicYearId);
    return map;
  }

  CachedEnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return CachedEnrollmentsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      sectionId: Value(sectionId),
      academicYearId: Value(academicYearId),
    );
  }

  factory CachedEnrollment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedEnrollment(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      academicYearId: serializer.fromJson<String>(json['academicYearId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'sectionId': serializer.toJson<String>(sectionId),
      'academicYearId': serializer.toJson<String>(academicYearId),
    };
  }

  CachedEnrollment copyWith({
    String? id,
    String? studentId,
    String? sectionId,
    String? academicYearId,
  }) => CachedEnrollment(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    sectionId: sectionId ?? this.sectionId,
    academicYearId: academicYearId ?? this.academicYearId,
  );
  CachedEnrollment copyWithCompanion(CachedEnrollmentsCompanion data) {
    return CachedEnrollment(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      academicYearId: data.academicYearId.present
          ? data.academicYearId.value
          : this.academicYearId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedEnrollment(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sectionId: $sectionId, ')
          ..write('academicYearId: $academicYearId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, sectionId, academicYearId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedEnrollment &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.sectionId == this.sectionId &&
          other.academicYearId == this.academicYearId);
}

class CachedEnrollmentsCompanion extends UpdateCompanion<CachedEnrollment> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> sectionId;
  final Value<String> academicYearId;
  final Value<int> rowid;
  const CachedEnrollmentsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.academicYearId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedEnrollmentsCompanion.insert({
    required String id,
    required String studentId,
    required String sectionId,
    required String academicYearId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       sectionId = Value(sectionId),
       academicYearId = Value(academicYearId);
  static Insertable<CachedEnrollment> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? sectionId,
    Expression<String>? academicYearId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (sectionId != null) 'section_id': sectionId,
      if (academicYearId != null) 'academic_year_id': academicYearId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedEnrollmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? sectionId,
    Value<String>? academicYearId,
    Value<int>? rowid,
  }) {
    return CachedEnrollmentsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      sectionId: sectionId ?? this.sectionId,
      academicYearId: academicYearId ?? this.academicYearId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (academicYearId.present) {
      map['academic_year_id'] = Variable<String>(academicYearId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedEnrollmentsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sectionId: $sectionId, ')
          ..write('academicYearId: $academicYearId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedScheduleTable extends CachedSchedule
    with TableInfo<$CachedScheduleTable, CachedScheduleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedScheduleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionNameMeta = const VerificationMeta(
    'sectionName',
  );
  @override
  late final GeneratedColumn<String> sectionName = GeneratedColumn<String>(
    'section_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherNameMeta = const VerificationMeta(
    'teacherName',
  );
  @override
  late final GeneratedColumn<String> teacherName = GeneratedColumn<String>(
    'teacher_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sectionId,
    sectionName,
    subjectId,
    subjectName,
    teacherName,
    dayOfWeek,
    startTime,
    endTime,
    room,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_schedule';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedScheduleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('section_name')) {
      context.handle(
        _sectionNameMeta,
        sectionName.isAcceptableOrUnknown(
          data['section_name']!,
          _sectionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectionNameMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectNameMeta);
    }
    if (data.containsKey('teacher_name')) {
      context.handle(
        _teacherNameMeta,
        teacherName.isAcceptableOrUnknown(
          data['teacher_name']!,
          _teacherNameMeta,
        ),
      );
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedScheduleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedScheduleData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      sectionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_name'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      )!,
      teacherName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_name'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      ),
    );
  }

  @override
  $CachedScheduleTable createAlias(String alias) {
    return $CachedScheduleTable(attachedDatabase, alias);
  }
}

class CachedScheduleData extends DataClass
    implements Insertable<CachedScheduleData> {
  final String id;
  final String sectionId;
  final String sectionName;
  final String subjectId;
  final String subjectName;
  final String teacherName;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? room;
  const CachedScheduleData({
    required this.id,
    required this.sectionId,
    required this.sectionName,
    required this.subjectId,
    required this.subjectName,
    required this.teacherName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['section_id'] = Variable<String>(sectionId);
    map['section_name'] = Variable<String>(sectionName);
    map['subject_id'] = Variable<String>(subjectId);
    map['subject_name'] = Variable<String>(subjectName);
    map['teacher_name'] = Variable<String>(teacherName);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    return map;
  }

  CachedScheduleCompanion toCompanion(bool nullToAbsent) {
    return CachedScheduleCompanion(
      id: Value(id),
      sectionId: Value(sectionId),
      sectionName: Value(sectionName),
      subjectId: Value(subjectId),
      subjectName: Value(subjectName),
      teacherName: Value(teacherName),
      dayOfWeek: Value(dayOfWeek),
      startTime: Value(startTime),
      endTime: Value(endTime),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
    );
  }

  factory CachedScheduleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedScheduleData(
      id: serializer.fromJson<String>(json['id']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      sectionName: serializer.fromJson<String>(json['sectionName']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      subjectName: serializer.fromJson<String>(json['subjectName']),
      teacherName: serializer.fromJson<String>(json['teacherName']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      room: serializer.fromJson<String?>(json['room']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sectionId': serializer.toJson<String>(sectionId),
      'sectionName': serializer.toJson<String>(sectionName),
      'subjectId': serializer.toJson<String>(subjectId),
      'subjectName': serializer.toJson<String>(subjectName),
      'teacherName': serializer.toJson<String>(teacherName),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'room': serializer.toJson<String?>(room),
    };
  }

  CachedScheduleData copyWith({
    String? id,
    String? sectionId,
    String? sectionName,
    String? subjectId,
    String? subjectName,
    String? teacherName,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    Value<String?> room = const Value.absent(),
  }) => CachedScheduleData(
    id: id ?? this.id,
    sectionId: sectionId ?? this.sectionId,
    sectionName: sectionName ?? this.sectionName,
    subjectId: subjectId ?? this.subjectId,
    subjectName: subjectName ?? this.subjectName,
    teacherName: teacherName ?? this.teacherName,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    room: room.present ? room.value : this.room,
  );
  CachedScheduleData copyWithCompanion(CachedScheduleCompanion data) {
    return CachedScheduleData(
      id: data.id.present ? data.id.value : this.id,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      sectionName: data.sectionName.present
          ? data.sectionName.value
          : this.sectionName,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      teacherName: data.teacherName.present
          ? data.teacherName.value
          : this.teacherName,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      room: data.room.present ? data.room.value : this.room,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedScheduleData(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('sectionName: $sectionName, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectName: $subjectName, ')
          ..write('teacherName: $teacherName, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('room: $room')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sectionId,
    sectionName,
    subjectId,
    subjectName,
    teacherName,
    dayOfWeek,
    startTime,
    endTime,
    room,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedScheduleData &&
          other.id == this.id &&
          other.sectionId == this.sectionId &&
          other.sectionName == this.sectionName &&
          other.subjectId == this.subjectId &&
          other.subjectName == this.subjectName &&
          other.teacherName == this.teacherName &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.room == this.room);
}

class CachedScheduleCompanion extends UpdateCompanion<CachedScheduleData> {
  final Value<String> id;
  final Value<String> sectionId;
  final Value<String> sectionName;
  final Value<String> subjectId;
  final Value<String> subjectName;
  final Value<String> teacherName;
  final Value<int> dayOfWeek;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String?> room;
  final Value<int> rowid;
  const CachedScheduleCompanion({
    this.id = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.teacherName = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.room = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedScheduleCompanion.insert({
    required String id,
    required String sectionId,
    required String sectionName,
    required String subjectId,
    required String subjectName,
    this.teacherName = const Value.absent(),
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    this.room = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sectionId = Value(sectionId),
       sectionName = Value(sectionName),
       subjectId = Value(subjectId),
       subjectName = Value(subjectName),
       dayOfWeek = Value(dayOfWeek),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<CachedScheduleData> custom({
    Expression<String>? id,
    Expression<String>? sectionId,
    Expression<String>? sectionName,
    Expression<String>? subjectId,
    Expression<String>? subjectName,
    Expression<String>? teacherName,
    Expression<int>? dayOfWeek,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? room,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sectionId != null) 'section_id': sectionId,
      if (sectionName != null) 'section_name': sectionName,
      if (subjectId != null) 'subject_id': subjectId,
      if (subjectName != null) 'subject_name': subjectName,
      if (teacherName != null) 'teacher_name': teacherName,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (room != null) 'room': room,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedScheduleCompanion copyWith({
    Value<String>? id,
    Value<String>? sectionId,
    Value<String>? sectionName,
    Value<String>? subjectId,
    Value<String>? subjectName,
    Value<String>? teacherName,
    Value<int>? dayOfWeek,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<String?>? room,
    Value<int>? rowid,
  }) {
    return CachedScheduleCompanion(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      teacherName: teacherName ?? this.teacherName,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (sectionName.present) {
      map['section_name'] = Variable<String>(sectionName.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (teacherName.present) {
      map['teacher_name'] = Variable<String>(teacherName.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedScheduleCompanion(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('sectionName: $sectionName, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectName: $subjectName, ')
          ..write('teacherName: $teacherName, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('room: $room, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceMarksTable extends AttendanceMarks
    with TableInfo<$AttendanceMarksTable, AttendanceMark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceMarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enrollmentIdMeta = const VerificationMeta(
    'enrollmentId',
  );
  @override
  late final GeneratedColumn<String> enrollmentId = GeneratedColumn<String>(
    'enrollment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverStatusMeta = const VerificationMeta(
    'serverStatus',
  );
  @override
  late final GeneratedColumn<String> serverStatus = GeneratedColumn<String>(
    'server_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverRemarksMeta = const VerificationMeta(
    'serverRemarks',
  );
  @override
  late final GeneratedColumn<String> serverRemarks = GeneratedColumn<String>(
    'server_remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> serverUpdatedAt = GeneratedColumn<String>(
    'server_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localRemarksMeta = const VerificationMeta(
    'localRemarks',
  );
  @override
  late final GeneratedColumn<String> localRemarks = GeneratedColumn<String>(
    'local_remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseUpdatedAtMeta = const VerificationMeta(
    'baseUpdatedAt',
  );
  @override
  late final GeneratedColumn<String> baseUpdatedAt = GeneratedColumn<String>(
    'base_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _conflictMeta = const VerificationMeta(
    'conflict',
  );
  @override
  late final GeneratedColumn<bool> conflict = GeneratedColumn<bool>(
    'conflict',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("conflict" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    sectionId,
    date,
    studentId,
    enrollmentId,
    serverStatus,
    serverRemarks,
    serverUpdatedAt,
    localStatus,
    localRemarks,
    baseUpdatedAt,
    dirty,
    conflict,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_marks';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceMark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('enrollment_id')) {
      context.handle(
        _enrollmentIdMeta,
        enrollmentId.isAcceptableOrUnknown(
          data['enrollment_id']!,
          _enrollmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_enrollmentIdMeta);
    }
    if (data.containsKey('server_status')) {
      context.handle(
        _serverStatusMeta,
        serverStatus.isAcceptableOrUnknown(
          data['server_status']!,
          _serverStatusMeta,
        ),
      );
    }
    if (data.containsKey('server_remarks')) {
      context.handle(
        _serverRemarksMeta,
        serverRemarks.isAcceptableOrUnknown(
          data['server_remarks']!,
          _serverRemarksMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('local_remarks')) {
      context.handle(
        _localRemarksMeta,
        localRemarks.isAcceptableOrUnknown(
          data['local_remarks']!,
          _localRemarksMeta,
        ),
      );
    }
    if (data.containsKey('base_updated_at')) {
      context.handle(
        _baseUpdatedAtMeta,
        baseUpdatedAt.isAcceptableOrUnknown(
          data['base_updated_at']!,
          _baseUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('conflict')) {
      context.handle(
        _conflictMeta,
        conflict.isAcceptableOrUnknown(data['conflict']!, _conflictMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sectionId, date, studentId};
  @override
  AttendanceMark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceMark(
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      enrollmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment_id'],
      )!,
      serverStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_status'],
      ),
      serverRemarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_remarks'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_updated_at'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      ),
      localRemarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_remarks'],
      ),
      baseUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_updated_at'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      conflict: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}conflict'],
      )!,
    );
  }

  @override
  $AttendanceMarksTable createAlias(String alias) {
    return $AttendanceMarksTable(attachedDatabase, alias);
  }
}

class AttendanceMark extends DataClass implements Insertable<AttendanceMark> {
  final String sectionId;
  final String date;
  final String studentId;
  final String enrollmentId;
  final String? serverStatus;
  final String? serverRemarks;
  final String? serverUpdatedAt;
  final String? localStatus;
  final String? localRemarks;

  /// Server version the local edit was based on (captured when the teacher saved).
  final String? baseUpdatedAt;
  final bool dirty;
  final bool conflict;
  const AttendanceMark({
    required this.sectionId,
    required this.date,
    required this.studentId,
    required this.enrollmentId,
    this.serverStatus,
    this.serverRemarks,
    this.serverUpdatedAt,
    this.localStatus,
    this.localRemarks,
    this.baseUpdatedAt,
    required this.dirty,
    required this.conflict,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['section_id'] = Variable<String>(sectionId);
    map['date'] = Variable<String>(date);
    map['student_id'] = Variable<String>(studentId);
    map['enrollment_id'] = Variable<String>(enrollmentId);
    if (!nullToAbsent || serverStatus != null) {
      map['server_status'] = Variable<String>(serverStatus);
    }
    if (!nullToAbsent || serverRemarks != null) {
      map['server_remarks'] = Variable<String>(serverRemarks);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<String>(serverUpdatedAt);
    }
    if (!nullToAbsent || localStatus != null) {
      map['local_status'] = Variable<String>(localStatus);
    }
    if (!nullToAbsent || localRemarks != null) {
      map['local_remarks'] = Variable<String>(localRemarks);
    }
    if (!nullToAbsent || baseUpdatedAt != null) {
      map['base_updated_at'] = Variable<String>(baseUpdatedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    map['conflict'] = Variable<bool>(conflict);
    return map;
  }

  AttendanceMarksCompanion toCompanion(bool nullToAbsent) {
    return AttendanceMarksCompanion(
      sectionId: Value(sectionId),
      date: Value(date),
      studentId: Value(studentId),
      enrollmentId: Value(enrollmentId),
      serverStatus: serverStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(serverStatus),
      serverRemarks: serverRemarks == null && nullToAbsent
          ? const Value.absent()
          : Value(serverRemarks),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      localStatus: localStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(localStatus),
      localRemarks: localRemarks == null && nullToAbsent
          ? const Value.absent()
          : Value(localRemarks),
      baseUpdatedAt: baseUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUpdatedAt),
      dirty: Value(dirty),
      conflict: Value(conflict),
    );
  }

  factory AttendanceMark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceMark(
      sectionId: serializer.fromJson<String>(json['sectionId']),
      date: serializer.fromJson<String>(json['date']),
      studentId: serializer.fromJson<String>(json['studentId']),
      enrollmentId: serializer.fromJson<String>(json['enrollmentId']),
      serverStatus: serializer.fromJson<String?>(json['serverStatus']),
      serverRemarks: serializer.fromJson<String?>(json['serverRemarks']),
      serverUpdatedAt: serializer.fromJson<String?>(json['serverUpdatedAt']),
      localStatus: serializer.fromJson<String?>(json['localStatus']),
      localRemarks: serializer.fromJson<String?>(json['localRemarks']),
      baseUpdatedAt: serializer.fromJson<String?>(json['baseUpdatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      conflict: serializer.fromJson<bool>(json['conflict']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sectionId': serializer.toJson<String>(sectionId),
      'date': serializer.toJson<String>(date),
      'studentId': serializer.toJson<String>(studentId),
      'enrollmentId': serializer.toJson<String>(enrollmentId),
      'serverStatus': serializer.toJson<String?>(serverStatus),
      'serverRemarks': serializer.toJson<String?>(serverRemarks),
      'serverUpdatedAt': serializer.toJson<String?>(serverUpdatedAt),
      'localStatus': serializer.toJson<String?>(localStatus),
      'localRemarks': serializer.toJson<String?>(localRemarks),
      'baseUpdatedAt': serializer.toJson<String?>(baseUpdatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'conflict': serializer.toJson<bool>(conflict),
    };
  }

  AttendanceMark copyWith({
    String? sectionId,
    String? date,
    String? studentId,
    String? enrollmentId,
    Value<String?> serverStatus = const Value.absent(),
    Value<String?> serverRemarks = const Value.absent(),
    Value<String?> serverUpdatedAt = const Value.absent(),
    Value<String?> localStatus = const Value.absent(),
    Value<String?> localRemarks = const Value.absent(),
    Value<String?> baseUpdatedAt = const Value.absent(),
    bool? dirty,
    bool? conflict,
  }) => AttendanceMark(
    sectionId: sectionId ?? this.sectionId,
    date: date ?? this.date,
    studentId: studentId ?? this.studentId,
    enrollmentId: enrollmentId ?? this.enrollmentId,
    serverStatus: serverStatus.present ? serverStatus.value : this.serverStatus,
    serverRemarks: serverRemarks.present
        ? serverRemarks.value
        : this.serverRemarks,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    localStatus: localStatus.present ? localStatus.value : this.localStatus,
    localRemarks: localRemarks.present ? localRemarks.value : this.localRemarks,
    baseUpdatedAt: baseUpdatedAt.present
        ? baseUpdatedAt.value
        : this.baseUpdatedAt,
    dirty: dirty ?? this.dirty,
    conflict: conflict ?? this.conflict,
  );
  AttendanceMark copyWithCompanion(AttendanceMarksCompanion data) {
    return AttendanceMark(
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      date: data.date.present ? data.date.value : this.date,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      enrollmentId: data.enrollmentId.present
          ? data.enrollmentId.value
          : this.enrollmentId,
      serverStatus: data.serverStatus.present
          ? data.serverStatus.value
          : this.serverStatus,
      serverRemarks: data.serverRemarks.present
          ? data.serverRemarks.value
          : this.serverRemarks,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      localRemarks: data.localRemarks.present
          ? data.localRemarks.value
          : this.localRemarks,
      baseUpdatedAt: data.baseUpdatedAt.present
          ? data.baseUpdatedAt.value
          : this.baseUpdatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      conflict: data.conflict.present ? data.conflict.value : this.conflict,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceMark(')
          ..write('sectionId: $sectionId, ')
          ..write('date: $date, ')
          ..write('studentId: $studentId, ')
          ..write('enrollmentId: $enrollmentId, ')
          ..write('serverStatus: $serverStatus, ')
          ..write('serverRemarks: $serverRemarks, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('localStatus: $localStatus, ')
          ..write('localRemarks: $localRemarks, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('conflict: $conflict')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sectionId,
    date,
    studentId,
    enrollmentId,
    serverStatus,
    serverRemarks,
    serverUpdatedAt,
    localStatus,
    localRemarks,
    baseUpdatedAt,
    dirty,
    conflict,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceMark &&
          other.sectionId == this.sectionId &&
          other.date == this.date &&
          other.studentId == this.studentId &&
          other.enrollmentId == this.enrollmentId &&
          other.serverStatus == this.serverStatus &&
          other.serverRemarks == this.serverRemarks &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.localStatus == this.localStatus &&
          other.localRemarks == this.localRemarks &&
          other.baseUpdatedAt == this.baseUpdatedAt &&
          other.dirty == this.dirty &&
          other.conflict == this.conflict);
}

class AttendanceMarksCompanion extends UpdateCompanion<AttendanceMark> {
  final Value<String> sectionId;
  final Value<String> date;
  final Value<String> studentId;
  final Value<String> enrollmentId;
  final Value<String?> serverStatus;
  final Value<String?> serverRemarks;
  final Value<String?> serverUpdatedAt;
  final Value<String?> localStatus;
  final Value<String?> localRemarks;
  final Value<String?> baseUpdatedAt;
  final Value<bool> dirty;
  final Value<bool> conflict;
  final Value<int> rowid;
  const AttendanceMarksCompanion({
    this.sectionId = const Value.absent(),
    this.date = const Value.absent(),
    this.studentId = const Value.absent(),
    this.enrollmentId = const Value.absent(),
    this.serverStatus = const Value.absent(),
    this.serverRemarks = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.localRemarks = const Value.absent(),
    this.baseUpdatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.conflict = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceMarksCompanion.insert({
    required String sectionId,
    required String date,
    required String studentId,
    required String enrollmentId,
    this.serverStatus = const Value.absent(),
    this.serverRemarks = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.localRemarks = const Value.absent(),
    this.baseUpdatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.conflict = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sectionId = Value(sectionId),
       date = Value(date),
       studentId = Value(studentId),
       enrollmentId = Value(enrollmentId);
  static Insertable<AttendanceMark> custom({
    Expression<String>? sectionId,
    Expression<String>? date,
    Expression<String>? studentId,
    Expression<String>? enrollmentId,
    Expression<String>? serverStatus,
    Expression<String>? serverRemarks,
    Expression<String>? serverUpdatedAt,
    Expression<String>? localStatus,
    Expression<String>? localRemarks,
    Expression<String>? baseUpdatedAt,
    Expression<bool>? dirty,
    Expression<bool>? conflict,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sectionId != null) 'section_id': sectionId,
      if (date != null) 'date': date,
      if (studentId != null) 'student_id': studentId,
      if (enrollmentId != null) 'enrollment_id': enrollmentId,
      if (serverStatus != null) 'server_status': serverStatus,
      if (serverRemarks != null) 'server_remarks': serverRemarks,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (localStatus != null) 'local_status': localStatus,
      if (localRemarks != null) 'local_remarks': localRemarks,
      if (baseUpdatedAt != null) 'base_updated_at': baseUpdatedAt,
      if (dirty != null) 'dirty': dirty,
      if (conflict != null) 'conflict': conflict,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceMarksCompanion copyWith({
    Value<String>? sectionId,
    Value<String>? date,
    Value<String>? studentId,
    Value<String>? enrollmentId,
    Value<String?>? serverStatus,
    Value<String?>? serverRemarks,
    Value<String?>? serverUpdatedAt,
    Value<String?>? localStatus,
    Value<String?>? localRemarks,
    Value<String?>? baseUpdatedAt,
    Value<bool>? dirty,
    Value<bool>? conflict,
    Value<int>? rowid,
  }) {
    return AttendanceMarksCompanion(
      sectionId: sectionId ?? this.sectionId,
      date: date ?? this.date,
      studentId: studentId ?? this.studentId,
      enrollmentId: enrollmentId ?? this.enrollmentId,
      serverStatus: serverStatus ?? this.serverStatus,
      serverRemarks: serverRemarks ?? this.serverRemarks,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      localStatus: localStatus ?? this.localStatus,
      localRemarks: localRemarks ?? this.localRemarks,
      baseUpdatedAt: baseUpdatedAt ?? this.baseUpdatedAt,
      dirty: dirty ?? this.dirty,
      conflict: conflict ?? this.conflict,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (enrollmentId.present) {
      map['enrollment_id'] = Variable<String>(enrollmentId.value);
    }
    if (serverStatus.present) {
      map['server_status'] = Variable<String>(serverStatus.value);
    }
    if (serverRemarks.present) {
      map['server_remarks'] = Variable<String>(serverRemarks.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<String>(serverUpdatedAt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (localRemarks.present) {
      map['local_remarks'] = Variable<String>(localRemarks.value);
    }
    if (baseUpdatedAt.present) {
      map['base_updated_at'] = Variable<String>(baseUpdatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (conflict.present) {
      map['conflict'] = Variable<bool>(conflict.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceMarksCompanion(')
          ..write('sectionId: $sectionId, ')
          ..write('date: $date, ')
          ..write('studentId: $studentId, ')
          ..write('enrollmentId: $enrollmentId, ')
          ..write('serverStatus: $serverStatus, ')
          ..write('serverRemarks: $serverRemarks, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('localStatus: $localStatus, ')
          ..write('localRemarks: $localRemarks, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('conflict: $conflict, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedGradesTable extends CachedGrades
    with TableInfo<$CachedGradesTable, CachedGrade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedGradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodNameMeta = const VerificationMeta(
    'periodName',
  );
  @override
  late final GeneratedColumn<String> periodName = GeneratedColumn<String>(
    'period_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodSequenceMeta = const VerificationMeta(
    'periodSequence',
  );
  @override
  late final GeneratedColumn<int> periodSequence = GeneratedColumn<int>(
    'period_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<String> score = GeneratedColumn<String>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    sectionId,
    subjectName,
    periodName,
    periodSequence,
    score,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_grades';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedGrade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectNameMeta);
    }
    if (data.containsKey('period_name')) {
      context.handle(
        _periodNameMeta,
        periodName.isAcceptableOrUnknown(data['period_name']!, _periodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_periodNameMeta);
    }
    if (data.containsKey('period_sequence')) {
      context.handle(
        _periodSequenceMeta,
        periodSequence.isAcceptableOrUnknown(
          data['period_sequence']!,
          _periodSequenceMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedGrade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedGrade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      )!,
      periodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_name'],
      )!,
      periodSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_sequence'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}score'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $CachedGradesTable createAlias(String alias) {
    return $CachedGradesTable(attachedDatabase, alias);
  }
}

class CachedGrade extends DataClass implements Insertable<CachedGrade> {
  final String id;
  final String studentId;
  final String sectionId;
  final String subjectName;
  final String periodName;
  final int periodSequence;
  final String? score;
  final String status;
  const CachedGrade({
    required this.id,
    required this.studentId,
    required this.sectionId,
    required this.subjectName,
    required this.periodName,
    required this.periodSequence,
    this.score,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['section_id'] = Variable<String>(sectionId);
    map['subject_name'] = Variable<String>(subjectName);
    map['period_name'] = Variable<String>(periodName);
    map['period_sequence'] = Variable<int>(periodSequence);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<String>(score);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  CachedGradesCompanion toCompanion(bool nullToAbsent) {
    return CachedGradesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      sectionId: Value(sectionId),
      subjectName: Value(subjectName),
      periodName: Value(periodName),
      periodSequence: Value(periodSequence),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      status: Value(status),
    );
  }

  factory CachedGrade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedGrade(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      subjectName: serializer.fromJson<String>(json['subjectName']),
      periodName: serializer.fromJson<String>(json['periodName']),
      periodSequence: serializer.fromJson<int>(json['periodSequence']),
      score: serializer.fromJson<String?>(json['score']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'sectionId': serializer.toJson<String>(sectionId),
      'subjectName': serializer.toJson<String>(subjectName),
      'periodName': serializer.toJson<String>(periodName),
      'periodSequence': serializer.toJson<int>(periodSequence),
      'score': serializer.toJson<String?>(score),
      'status': serializer.toJson<String>(status),
    };
  }

  CachedGrade copyWith({
    String? id,
    String? studentId,
    String? sectionId,
    String? subjectName,
    String? periodName,
    int? periodSequence,
    Value<String?> score = const Value.absent(),
    String? status,
  }) => CachedGrade(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    sectionId: sectionId ?? this.sectionId,
    subjectName: subjectName ?? this.subjectName,
    periodName: periodName ?? this.periodName,
    periodSequence: periodSequence ?? this.periodSequence,
    score: score.present ? score.value : this.score,
    status: status ?? this.status,
  );
  CachedGrade copyWithCompanion(CachedGradesCompanion data) {
    return CachedGrade(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      periodName: data.periodName.present
          ? data.periodName.value
          : this.periodName,
      periodSequence: data.periodSequence.present
          ? data.periodSequence.value
          : this.periodSequence,
      score: data.score.present ? data.score.value : this.score,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedGrade(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sectionId: $sectionId, ')
          ..write('subjectName: $subjectName, ')
          ..write('periodName: $periodName, ')
          ..write('periodSequence: $periodSequence, ')
          ..write('score: $score, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    sectionId,
    subjectName,
    periodName,
    periodSequence,
    score,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedGrade &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.sectionId == this.sectionId &&
          other.subjectName == this.subjectName &&
          other.periodName == this.periodName &&
          other.periodSequence == this.periodSequence &&
          other.score == this.score &&
          other.status == this.status);
}

class CachedGradesCompanion extends UpdateCompanion<CachedGrade> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> sectionId;
  final Value<String> subjectName;
  final Value<String> periodName;
  final Value<int> periodSequence;
  final Value<String?> score;
  final Value<String> status;
  final Value<int> rowid;
  const CachedGradesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.periodName = const Value.absent(),
    this.periodSequence = const Value.absent(),
    this.score = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedGradesCompanion.insert({
    required String id,
    required String studentId,
    required String sectionId,
    required String subjectName,
    required String periodName,
    this.periodSequence = const Value.absent(),
    this.score = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       sectionId = Value(sectionId),
       subjectName = Value(subjectName),
       periodName = Value(periodName),
       status = Value(status);
  static Insertable<CachedGrade> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? sectionId,
    Expression<String>? subjectName,
    Expression<String>? periodName,
    Expression<int>? periodSequence,
    Expression<String>? score,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (sectionId != null) 'section_id': sectionId,
      if (subjectName != null) 'subject_name': subjectName,
      if (periodName != null) 'period_name': periodName,
      if (periodSequence != null) 'period_sequence': periodSequence,
      if (score != null) 'score': score,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedGradesCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? sectionId,
    Value<String>? subjectName,
    Value<String>? periodName,
    Value<int>? periodSequence,
    Value<String?>? score,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return CachedGradesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      sectionId: sectionId ?? this.sectionId,
      subjectName: subjectName ?? this.subjectName,
      periodName: periodName ?? this.periodName,
      periodSequence: periodSequence ?? this.periodSequence,
      score: score ?? this.score,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (periodName.present) {
      map['period_name'] = Variable<String>(periodName.value);
    }
    if (periodSequence.present) {
      map['period_sequence'] = Variable<int>(periodSequence.value);
    }
    if (score.present) {
      map['score'] = Variable<String>(score.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedGradesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sectionId: $sectionId, ')
          ..write('subjectName: $subjectName, ')
          ..write('periodName: $periodName, ')
          ..write('periodSequence: $periodSequence, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAssignmentsTable extends CachedAssignments
    with TableInfo<$CachedAssignmentsTable, CachedAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionNameMeta = const VerificationMeta(
    'sectionName',
  );
  @override
  late final GeneratedColumn<String> sectionName = GeneratedColumn<String>(
    'section_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherNameMeta = const VerificationMeta(
    'teacherName',
  );
  @override
  late final GeneratedColumn<String> teacherName = GeneratedColumn<String>(
    'teacher_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sectionId,
    sectionName,
    subjectName,
    teacherName,
    title,
    description,
    dueAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('section_name')) {
      context.handle(
        _sectionNameMeta,
        sectionName.isAcceptableOrUnknown(
          data['section_name']!,
          _sectionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectionNameMeta);
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectNameMeta);
    }
    if (data.containsKey('teacher_name')) {
      context.handle(
        _teacherNameMeta,
        teacherName.isAcceptableOrUnknown(
          data['teacher_name']!,
          _teacherNameMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAssignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      sectionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_name'],
      )!,
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      )!,
      teacherName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_name'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $CachedAssignmentsTable createAlias(String alias) {
    return $CachedAssignmentsTable(attachedDatabase, alias);
  }
}

class CachedAssignment extends DataClass
    implements Insertable<CachedAssignment> {
  final String id;
  final String sectionId;
  final String sectionName;
  final String subjectName;
  final String teacherName;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final String status;
  const CachedAssignment({
    required this.id,
    required this.sectionId,
    required this.sectionName,
    required this.subjectName,
    required this.teacherName,
    required this.title,
    this.description,
    this.dueAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['section_id'] = Variable<String>(sectionId);
    map['section_name'] = Variable<String>(sectionName);
    map['subject_name'] = Variable<String>(subjectName);
    map['teacher_name'] = Variable<String>(teacherName);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  CachedAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return CachedAssignmentsCompanion(
      id: Value(id),
      sectionId: Value(sectionId),
      sectionName: Value(sectionName),
      subjectName: Value(subjectName),
      teacherName: Value(teacherName),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      status: Value(status),
    );
  }

  factory CachedAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAssignment(
      id: serializer.fromJson<String>(json['id']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      sectionName: serializer.fromJson<String>(json['sectionName']),
      subjectName: serializer.fromJson<String>(json['subjectName']),
      teacherName: serializer.fromJson<String>(json['teacherName']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sectionId': serializer.toJson<String>(sectionId),
      'sectionName': serializer.toJson<String>(sectionName),
      'subjectName': serializer.toJson<String>(subjectName),
      'teacherName': serializer.toJson<String>(teacherName),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'status': serializer.toJson<String>(status),
    };
  }

  CachedAssignment copyWith({
    String? id,
    String? sectionId,
    String? sectionName,
    String? subjectName,
    String? teacherName,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dueAt = const Value.absent(),
    String? status,
  }) => CachedAssignment(
    id: id ?? this.id,
    sectionId: sectionId ?? this.sectionId,
    sectionName: sectionName ?? this.sectionName,
    subjectName: subjectName ?? this.subjectName,
    teacherName: teacherName ?? this.teacherName,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    status: status ?? this.status,
  );
  CachedAssignment copyWithCompanion(CachedAssignmentsCompanion data) {
    return CachedAssignment(
      id: data.id.present ? data.id.value : this.id,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      sectionName: data.sectionName.present
          ? data.sectionName.value
          : this.sectionName,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      teacherName: data.teacherName.present
          ? data.teacherName.value
          : this.teacherName,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssignment(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('sectionName: $sectionName, ')
          ..write('subjectName: $subjectName, ')
          ..write('teacherName: $teacherName, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueAt: $dueAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sectionId,
    sectionName,
    subjectName,
    teacherName,
    title,
    description,
    dueAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAssignment &&
          other.id == this.id &&
          other.sectionId == this.sectionId &&
          other.sectionName == this.sectionName &&
          other.subjectName == this.subjectName &&
          other.teacherName == this.teacherName &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueAt == this.dueAt &&
          other.status == this.status);
}

class CachedAssignmentsCompanion extends UpdateCompanion<CachedAssignment> {
  final Value<String> id;
  final Value<String> sectionId;
  final Value<String> sectionName;
  final Value<String> subjectName;
  final Value<String> teacherName;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueAt;
  final Value<String> status;
  final Value<int> rowid;
  const CachedAssignmentsCompanion({
    this.id = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.teacherName = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAssignmentsCompanion.insert({
    required String id,
    required String sectionId,
    required String sectionName,
    required String subjectName,
    this.teacherName = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.dueAt = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sectionId = Value(sectionId),
       sectionName = Value(sectionName),
       subjectName = Value(subjectName),
       title = Value(title),
       status = Value(status);
  static Insertable<CachedAssignment> custom({
    Expression<String>? id,
    Expression<String>? sectionId,
    Expression<String>? sectionName,
    Expression<String>? subjectName,
    Expression<String>? teacherName,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sectionId != null) 'section_id': sectionId,
      if (sectionName != null) 'section_name': sectionName,
      if (subjectName != null) 'subject_name': subjectName,
      if (teacherName != null) 'teacher_name': teacherName,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueAt != null) 'due_at': dueAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? sectionId,
    Value<String>? sectionName,
    Value<String>? subjectName,
    Value<String>? teacherName,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime?>? dueAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return CachedAssignmentsCompanion(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      subjectName: subjectName ?? this.subjectName,
      teacherName: teacherName ?? this.teacherName,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (sectionName.present) {
      map['section_name'] = Variable<String>(sectionName.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (teacherName.present) {
      map['teacher_name'] = Variable<String>(teacherName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('sectionName: $sectionName, ')
          ..write('subjectName: $subjectName, ')
          ..write('teacherName: $teacherName, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueAt: $dueAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedChargesTable extends CachedCharges
    with TableInfo<$CachedChargesTable, CachedCharge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedChargesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _netAmountMeta = const VerificationMeta(
    'netAmount',
  );
  @override
  late final GeneratedColumn<String> netAmount = GeneratedColumn<String>(
    'net_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<String> paid = GeneratedColumn<String>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingMeta = const VerificationMeta(
    'remaining',
  );
  @override
  late final GeneratedColumn<String> remaining = GeneratedColumn<String>(
    'remaining',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    description,
    dueDate,
    netAmount,
    paid,
    remaining,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_charges';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCharge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('net_amount')) {
      context.handle(
        _netAmountMeta,
        netAmount.isAcceptableOrUnknown(data['net_amount']!, _netAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_netAmountMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    } else if (isInserting) {
      context.missing(_paidMeta);
    }
    if (data.containsKey('remaining')) {
      context.handle(
        _remainingMeta,
        remaining.isAcceptableOrUnknown(data['remaining']!, _remainingMeta),
      );
    } else if (isInserting) {
      context.missing(_remainingMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCharge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCharge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      netAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}net_amount'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid'],
      )!,
      remaining: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remaining'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $CachedChargesTable createAlias(String alias) {
    return $CachedChargesTable(attachedDatabase, alias);
  }
}

class CachedCharge extends DataClass implements Insertable<CachedCharge> {
  final String id;
  final String studentId;
  final String description;
  final String? dueDate;
  final String netAmount;
  final String paid;
  final String remaining;
  final String status;
  const CachedCharge({
    required this.id,
    required this.studentId,
    required this.description,
    this.dueDate,
    required this.netAmount,
    required this.paid,
    required this.remaining,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['net_amount'] = Variable<String>(netAmount);
    map['paid'] = Variable<String>(paid);
    map['remaining'] = Variable<String>(remaining);
    map['status'] = Variable<String>(status);
    return map;
  }

  CachedChargesCompanion toCompanion(bool nullToAbsent) {
    return CachedChargesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      description: Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      netAmount: Value(netAmount),
      paid: Value(paid),
      remaining: Value(remaining),
      status: Value(status),
    );
  }

  factory CachedCharge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCharge(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      description: serializer.fromJson<String>(json['description']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      netAmount: serializer.fromJson<String>(json['netAmount']),
      paid: serializer.fromJson<String>(json['paid']),
      remaining: serializer.fromJson<String>(json['remaining']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'description': serializer.toJson<String>(description),
      'dueDate': serializer.toJson<String?>(dueDate),
      'netAmount': serializer.toJson<String>(netAmount),
      'paid': serializer.toJson<String>(paid),
      'remaining': serializer.toJson<String>(remaining),
      'status': serializer.toJson<String>(status),
    };
  }

  CachedCharge copyWith({
    String? id,
    String? studentId,
    String? description,
    Value<String?> dueDate = const Value.absent(),
    String? netAmount,
    String? paid,
    String? remaining,
    String? status,
  }) => CachedCharge(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    description: description ?? this.description,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    netAmount: netAmount ?? this.netAmount,
    paid: paid ?? this.paid,
    remaining: remaining ?? this.remaining,
    status: status ?? this.status,
  );
  CachedCharge copyWithCompanion(CachedChargesCompanion data) {
    return CachedCharge(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      netAmount: data.netAmount.present ? data.netAmount.value : this.netAmount,
      paid: data.paid.present ? data.paid.value : this.paid,
      remaining: data.remaining.present ? data.remaining.value : this.remaining,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCharge(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('netAmount: $netAmount, ')
          ..write('paid: $paid, ')
          ..write('remaining: $remaining, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    description,
    dueDate,
    netAmount,
    paid,
    remaining,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCharge &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.netAmount == this.netAmount &&
          other.paid == this.paid &&
          other.remaining == this.remaining &&
          other.status == this.status);
}

class CachedChargesCompanion extends UpdateCompanion<CachedCharge> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> description;
  final Value<String?> dueDate;
  final Value<String> netAmount;
  final Value<String> paid;
  final Value<String> remaining;
  final Value<String> status;
  final Value<int> rowid;
  const CachedChargesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.netAmount = const Value.absent(),
    this.paid = const Value.absent(),
    this.remaining = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedChargesCompanion.insert({
    required String id,
    required String studentId,
    required String description,
    this.dueDate = const Value.absent(),
    required String netAmount,
    required String paid,
    required String remaining,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       description = Value(description),
       netAmount = Value(netAmount),
       paid = Value(paid),
       remaining = Value(remaining),
       status = Value(status);
  static Insertable<CachedCharge> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? description,
    Expression<String>? dueDate,
    Expression<String>? netAmount,
    Expression<String>? paid,
    Expression<String>? remaining,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (netAmount != null) 'net_amount': netAmount,
      if (paid != null) 'paid': paid,
      if (remaining != null) 'remaining': remaining,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedChargesCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? description,
    Value<String?>? dueDate,
    Value<String>? netAmount,
    Value<String>? paid,
    Value<String>? remaining,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return CachedChargesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      netAmount: netAmount ?? this.netAmount,
      paid: paid ?? this.paid,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (netAmount.present) {
      map['net_amount'] = Variable<String>(netAmount.value);
    }
    if (paid.present) {
      map['paid'] = Variable<String>(paid.value);
    }
    if (remaining.present) {
      map['remaining'] = Variable<String>(remaining.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedChargesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('netAmount: $netAmount, ')
          ..write('paid: $paid, ')
          ..write('remaining: $remaining, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPaymentsTable extends CachedPayments
    with TableInfo<$CachedPaymentsTable, CachedPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<String> paymentDate = GeneratedColumn<String>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    paymentDate,
    amount,
    currency,
    method,
    status,
    receiptNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      ),
    );
  }

  @override
  $CachedPaymentsTable createAlias(String alias) {
    return $CachedPaymentsTable(attachedDatabase, alias);
  }
}

class CachedPayment extends DataClass implements Insertable<CachedPayment> {
  final String id;
  final String studentId;
  final String paymentDate;
  final String amount;
  final String currency;
  final String method;
  final String status;
  final String? receiptNumber;
  const CachedPayment({
    required this.id,
    required this.studentId,
    required this.paymentDate,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.receiptNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['payment_date'] = Variable<String>(paymentDate);
    map['amount'] = Variable<String>(amount);
    map['currency'] = Variable<String>(currency);
    map['method'] = Variable<String>(method);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || receiptNumber != null) {
      map['receipt_number'] = Variable<String>(receiptNumber);
    }
    return map;
  }

  CachedPaymentsCompanion toCompanion(bool nullToAbsent) {
    return CachedPaymentsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      paymentDate: Value(paymentDate),
      amount: Value(amount),
      currency: Value(currency),
      method: Value(method),
      status: Value(status),
      receiptNumber: receiptNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNumber),
    );
  }

  factory CachedPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPayment(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      paymentDate: serializer.fromJson<String>(json['paymentDate']),
      amount: serializer.fromJson<String>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      method: serializer.fromJson<String>(json['method']),
      status: serializer.fromJson<String>(json['status']),
      receiptNumber: serializer.fromJson<String?>(json['receiptNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'paymentDate': serializer.toJson<String>(paymentDate),
      'amount': serializer.toJson<String>(amount),
      'currency': serializer.toJson<String>(currency),
      'method': serializer.toJson<String>(method),
      'status': serializer.toJson<String>(status),
      'receiptNumber': serializer.toJson<String?>(receiptNumber),
    };
  }

  CachedPayment copyWith({
    String? id,
    String? studentId,
    String? paymentDate,
    String? amount,
    String? currency,
    String? method,
    String? status,
    Value<String?> receiptNumber = const Value.absent(),
  }) => CachedPayment(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    paymentDate: paymentDate ?? this.paymentDate,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    method: method ?? this.method,
    status: status ?? this.status,
    receiptNumber: receiptNumber.present
        ? receiptNumber.value
        : this.receiptNumber,
  );
  CachedPayment copyWithCompanion(CachedPaymentsCompanion data) {
    return CachedPayment(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      method: data.method.present ? data.method.value : this.method,
      status: data.status.present ? data.status.value : this.status,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPayment(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('method: $method, ')
          ..write('status: $status, ')
          ..write('receiptNumber: $receiptNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    paymentDate,
    amount,
    currency,
    method,
    status,
    receiptNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPayment &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.paymentDate == this.paymentDate &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.method == this.method &&
          other.status == this.status &&
          other.receiptNumber == this.receiptNumber);
}

class CachedPaymentsCompanion extends UpdateCompanion<CachedPayment> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> paymentDate;
  final Value<String> amount;
  final Value<String> currency;
  final Value<String> method;
  final Value<String> status;
  final Value<String?> receiptNumber;
  final Value<int> rowid;
  const CachedPaymentsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.method = const Value.absent(),
    this.status = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPaymentsCompanion.insert({
    required String id,
    required String studentId,
    required String paymentDate,
    required String amount,
    required String currency,
    required String method,
    required String status,
    this.receiptNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       paymentDate = Value(paymentDate),
       amount = Value(amount),
       currency = Value(currency),
       method = Value(method),
       status = Value(status);
  static Insertable<CachedPayment> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? paymentDate,
    Expression<String>? amount,
    Expression<String>? currency,
    Expression<String>? method,
    Expression<String>? status,
    Expression<String>? receiptNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (method != null) 'method': method,
      if (status != null) 'status': status,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? paymentDate,
    Value<String>? amount,
    Value<String>? currency,
    Value<String>? method,
    Value<String>? status,
    Value<String?>? receiptNumber,
    Value<int>? rowid,
  }) {
    return CachedPaymentsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      paymentDate: paymentDate ?? this.paymentDate,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      method: method ?? this.method,
      status: status ?? this.status,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<String>(paymentDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('method: $method, ')
          ..write('status: $status, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    attemptCount,
    lastAttemptAt,
    status,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final int attemptCount;
  final DateTime? lastAttemptAt;
  final String status;
  final String? errorMessage;
  const SyncQueueData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.attemptCount,
    this.lastAttemptAt,
    required this.status,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attemptCount: Value(attemptCount),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    DateTime? createdAt,
    int? attemptCount,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    String? status,
    Value<String?> errorMessage = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    attemptCount,
    lastAttemptAt,
    status,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attemptCount == this.attemptCount &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attemptCount;
  final Value<DateTime?> lastAttemptAt;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attemptCount,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attemptCount,
    Value<DateTime?>? lastAttemptAt,
    Value<String>? status,
    Value<String?>? errorMessage,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $MetaEntriesTable metaEntries = $MetaEntriesTable(this);
  late final $CachedNotificationsTable cachedNotifications =
      $CachedNotificationsTable(this);
  late final $CachedAnnouncementsTable cachedAnnouncements =
      $CachedAnnouncementsTable(this);
  late final $CachedSectionsTable cachedSections = $CachedSectionsTable(this);
  late final $CachedStudentsTable cachedStudents = $CachedStudentsTable(this);
  late final $CachedEnrollmentsTable cachedEnrollments =
      $CachedEnrollmentsTable(this);
  late final $CachedScheduleTable cachedSchedule = $CachedScheduleTable(this);
  late final $AttendanceMarksTable attendanceMarks = $AttendanceMarksTable(
    this,
  );
  late final $CachedGradesTable cachedGrades = $CachedGradesTable(this);
  late final $CachedAssignmentsTable cachedAssignments =
      $CachedAssignmentsTable(this);
  late final $CachedChargesTable cachedCharges = $CachedChargesTable(this);
  late final $CachedPaymentsTable cachedPayments = $CachedPaymentsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    metaEntries,
    cachedNotifications,
    cachedAnnouncements,
    cachedSections,
    cachedStudents,
    cachedEnrollments,
    cachedSchedule,
    attendanceMarks,
    cachedGrades,
    cachedAssignments,
    cachedCharges,
    cachedPayments,
    syncQueue,
  ];
}

typedef $$MetaEntriesTableCreateCompanionBuilder =
    MetaEntriesCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MetaEntriesTableUpdateCompanionBuilder =
    MetaEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MetaEntriesTableFilterComposer
    extends Composer<_$LocalDatabase, $MetaEntriesTable> {
  $$MetaEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaEntriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $MetaEntriesTable> {
  $$MetaEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaEntriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $MetaEntriesTable> {
  $$MetaEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MetaEntriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $MetaEntriesTable,
          MetaEntry,
          $$MetaEntriesTableFilterComposer,
          $$MetaEntriesTableOrderingComposer,
          $$MetaEntriesTableAnnotationComposer,
          $$MetaEntriesTableCreateCompanionBuilder,
          $$MetaEntriesTableUpdateCompanionBuilder,
          (
            MetaEntry,
            BaseReferences<_$LocalDatabase, $MetaEntriesTable, MetaEntry>,
          ),
          MetaEntry,
          PrefetchHooks Function()
        > {
  $$MetaEntriesTableTableManager(_$LocalDatabase db, $MetaEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetaEntriesCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetaEntriesCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetaEntriesTable, MetaEntry>(table),
                  BaseReferences<_$LocalDatabase, $MetaEntriesTable, MetaEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $MetaEntriesTable,
      MetaEntry,
      $$MetaEntriesTableFilterComposer,
      $$MetaEntriesTableOrderingComposer,
      $$MetaEntriesTableAnnotationComposer,
      $$MetaEntriesTableCreateCompanionBuilder,
      $$MetaEntriesTableUpdateCompanionBuilder,
      (
        MetaEntry,
        BaseReferences<_$LocalDatabase, $MetaEntriesTable, MetaEntry>,
      ),
      MetaEntry,
      PrefetchHooks Function()
    >;
typedef $$CachedNotificationsTableCreateCompanionBuilder =
    CachedNotificationsCompanion Function({
      required String id,
      required String type,
      required String title,
      required String message,
      Value<String> data,
      Value<String> priority,
      required DateTime createdAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });
typedef $$CachedNotificationsTableUpdateCompanionBuilder =
    CachedNotificationsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<String> message,
      Value<String> data,
      Value<String> priority,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });

class $$CachedNotificationsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedNotificationsTable> {
  $$CachedNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedNotificationsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedNotificationsTable> {
  $$CachedNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedNotificationsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedNotificationsTable> {
  $$CachedNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$CachedNotificationsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedNotificationsTable,
          CachedNotification,
          $$CachedNotificationsTableFilterComposer,
          $$CachedNotificationsTableOrderingComposer,
          $$CachedNotificationsTableAnnotationComposer,
          $$CachedNotificationsTableCreateCompanionBuilder,
          $$CachedNotificationsTableUpdateCompanionBuilder,
          (
            CachedNotification,
            BaseReferences<
              _$LocalDatabase,
              $CachedNotificationsTable,
              CachedNotification
            >,
          ),
          CachedNotification,
          PrefetchHooks Function()
        > {
  $$CachedNotificationsTableTableManager(
    _$LocalDatabase db,
    $CachedNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedNotificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedNotificationsCompanion(
                id: id,
                type: type,
                title: title,
                message: message,
                data: data,
                priority: priority,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                required String message,
                Value<String> data = const Value.absent(),
                Value<String> priority = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedNotificationsCompanion.insert(
                id: id,
                type: type,
                title: title,
                message: message,
                data: data,
                priority: priority,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedNotificationsTable, CachedNotification>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedNotificationsTable,
                    CachedNotification
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedNotificationsTable,
      CachedNotification,
      $$CachedNotificationsTableFilterComposer,
      $$CachedNotificationsTableOrderingComposer,
      $$CachedNotificationsTableAnnotationComposer,
      $$CachedNotificationsTableCreateCompanionBuilder,
      $$CachedNotificationsTableUpdateCompanionBuilder,
      (
        CachedNotification,
        BaseReferences<
          _$LocalDatabase,
          $CachedNotificationsTable,
          CachedNotification
        >,
      ),
      CachedNotification,
      PrefetchHooks Function()
    >;
typedef $$CachedAnnouncementsTableCreateCompanionBuilder =
    CachedAnnouncementsCompanion Function({
      required String id,
      required String title,
      required String content,
      required String priority,
      Value<DateTime?> publishedAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$CachedAnnouncementsTableUpdateCompanionBuilder =
    CachedAnnouncementsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<String> priority,
      Value<DateTime?> publishedAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

class $$CachedAnnouncementsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedAnnouncementsTable> {
  $$CachedAnnouncementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAnnouncementsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedAnnouncementsTable> {
  $$CachedAnnouncementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAnnouncementsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedAnnouncementsTable> {
  $$CachedAnnouncementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$CachedAnnouncementsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedAnnouncementsTable,
          CachedAnnouncement,
          $$CachedAnnouncementsTableFilterComposer,
          $$CachedAnnouncementsTableOrderingComposer,
          $$CachedAnnouncementsTableAnnotationComposer,
          $$CachedAnnouncementsTableCreateCompanionBuilder,
          $$CachedAnnouncementsTableUpdateCompanionBuilder,
          (
            CachedAnnouncement,
            BaseReferences<
              _$LocalDatabase,
              $CachedAnnouncementsTable,
              CachedAnnouncement
            >,
          ),
          CachedAnnouncement,
          PrefetchHooks Function()
        > {
  $$CachedAnnouncementsTableTableManager(
    _$LocalDatabase db,
    $CachedAnnouncementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAnnouncementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAnnouncementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedAnnouncementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAnnouncementsCompanion(
                id: id,
                title: title,
                content: content,
                priority: priority,
                publishedAt: publishedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String content,
                required String priority,
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAnnouncementsCompanion.insert(
                id: id,
                title: title,
                content: content,
                priority: priority,
                publishedAt: publishedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedAnnouncementsTable, CachedAnnouncement>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedAnnouncementsTable,
                    CachedAnnouncement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAnnouncementsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedAnnouncementsTable,
      CachedAnnouncement,
      $$CachedAnnouncementsTableFilterComposer,
      $$CachedAnnouncementsTableOrderingComposer,
      $$CachedAnnouncementsTableAnnotationComposer,
      $$CachedAnnouncementsTableCreateCompanionBuilder,
      $$CachedAnnouncementsTableUpdateCompanionBuilder,
      (
        CachedAnnouncement,
        BaseReferences<
          _$LocalDatabase,
          $CachedAnnouncementsTable,
          CachedAnnouncement
        >,
      ),
      CachedAnnouncement,
      PrefetchHooks Function()
    >;
typedef $$CachedSectionsTableCreateCompanionBuilder =
    CachedSectionsCompanion Function({
      required String id,
      required String name,
      Value<String> gradeLevel,
      required String academicYearId,
      Value<int> rowid,
    });
typedef $$CachedSectionsTableUpdateCompanionBuilder =
    CachedSectionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> gradeLevel,
      Value<String> academicYearId,
      Value<int> rowid,
    });

class $$CachedSectionsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedSectionsTable> {
  $$CachedSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradeLevel => $composableBuilder(
    column: $table.gradeLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYearId => $composableBuilder(
    column: $table.academicYearId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSectionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedSectionsTable> {
  $$CachedSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradeLevel => $composableBuilder(
    column: $table.gradeLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYearId => $composableBuilder(
    column: $table.academicYearId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSectionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedSectionsTable> {
  $$CachedSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gradeLevel => $composableBuilder(
    column: $table.gradeLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get academicYearId => $composableBuilder(
    column: $table.academicYearId,
    builder: (column) => column,
  );
}

class $$CachedSectionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedSectionsTable,
          CachedSection,
          $$CachedSectionsTableFilterComposer,
          $$CachedSectionsTableOrderingComposer,
          $$CachedSectionsTableAnnotationComposer,
          $$CachedSectionsTableCreateCompanionBuilder,
          $$CachedSectionsTableUpdateCompanionBuilder,
          (
            CachedSection,
            BaseReferences<
              _$LocalDatabase,
              $CachedSectionsTable,
              CachedSection
            >,
          ),
          CachedSection,
          PrefetchHooks Function()
        > {
  $$CachedSectionsTableTableManager(
    _$LocalDatabase db,
    $CachedSectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> gradeLevel = const Value.absent(),
                Value<String> academicYearId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSectionsCompanion(
                id: id,
                name: name,
                gradeLevel: gradeLevel,
                academicYearId: academicYearId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> gradeLevel = const Value.absent(),
                required String academicYearId,
                Value<int> rowid = const Value.absent(),
              }) => CachedSectionsCompanion.insert(
                id: id,
                name: name,
                gradeLevel: gradeLevel,
                academicYearId: academicYearId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedSectionsTable, CachedSection>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedSectionsTable,
                    CachedSection
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedSectionsTable,
      CachedSection,
      $$CachedSectionsTableFilterComposer,
      $$CachedSectionsTableOrderingComposer,
      $$CachedSectionsTableAnnotationComposer,
      $$CachedSectionsTableCreateCompanionBuilder,
      $$CachedSectionsTableUpdateCompanionBuilder,
      (
        CachedSection,
        BaseReferences<_$LocalDatabase, $CachedSectionsTable, CachedSection>,
      ),
      CachedSection,
      PrefetchHooks Function()
    >;
typedef $$CachedStudentsTableCreateCompanionBuilder =
    CachedStudentsCompanion Function({
      required String id,
      required String studentNumber,
      required String firstName,
      required String lastName,
      Value<int> rowid,
    });
typedef $$CachedStudentsTableUpdateCompanionBuilder =
    CachedStudentsCompanion Function({
      Value<String> id,
      Value<String> studentNumber,
      Value<String> firstName,
      Value<String> lastName,
      Value<int> rowid,
    });

class $$CachedStudentsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedStudentsTable> {
  $$CachedStudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentNumber => $composableBuilder(
    column: $table.studentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedStudentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedStudentsTable> {
  $$CachedStudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentNumber => $composableBuilder(
    column: $table.studentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedStudentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedStudentsTable> {
  $$CachedStudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentNumber => $composableBuilder(
    column: $table.studentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);
}

class $$CachedStudentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedStudentsTable,
          CachedStudent,
          $$CachedStudentsTableFilterComposer,
          $$CachedStudentsTableOrderingComposer,
          $$CachedStudentsTableAnnotationComposer,
          $$CachedStudentsTableCreateCompanionBuilder,
          $$CachedStudentsTableUpdateCompanionBuilder,
          (
            CachedStudent,
            BaseReferences<
              _$LocalDatabase,
              $CachedStudentsTable,
              CachedStudent
            >,
          ),
          CachedStudent,
          PrefetchHooks Function()
        > {
  $$CachedStudentsTableTableManager(
    _$LocalDatabase db,
    $CachedStudentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedStudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedStudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedStudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentNumber = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedStudentsCompanion(
                id: id,
                studentNumber: studentNumber,
                firstName: firstName,
                lastName: lastName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentNumber,
                required String firstName,
                required String lastName,
                Value<int> rowid = const Value.absent(),
              }) => CachedStudentsCompanion.insert(
                id: id,
                studentNumber: studentNumber,
                firstName: firstName,
                lastName: lastName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedStudentsTable, CachedStudent>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedStudentsTable,
                    CachedStudent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedStudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedStudentsTable,
      CachedStudent,
      $$CachedStudentsTableFilterComposer,
      $$CachedStudentsTableOrderingComposer,
      $$CachedStudentsTableAnnotationComposer,
      $$CachedStudentsTableCreateCompanionBuilder,
      $$CachedStudentsTableUpdateCompanionBuilder,
      (
        CachedStudent,
        BaseReferences<_$LocalDatabase, $CachedStudentsTable, CachedStudent>,
      ),
      CachedStudent,
      PrefetchHooks Function()
    >;
typedef $$CachedEnrollmentsTableCreateCompanionBuilder =
    CachedEnrollmentsCompanion Function({
      required String id,
      required String studentId,
      required String sectionId,
      required String academicYearId,
      Value<int> rowid,
    });
typedef $$CachedEnrollmentsTableUpdateCompanionBuilder =
    CachedEnrollmentsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> sectionId,
      Value<String> academicYearId,
      Value<int> rowid,
    });

class $$CachedEnrollmentsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedEnrollmentsTable> {
  $$CachedEnrollmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYearId => $composableBuilder(
    column: $table.academicYearId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedEnrollmentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedEnrollmentsTable> {
  $$CachedEnrollmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYearId => $composableBuilder(
    column: $table.academicYearId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedEnrollmentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedEnrollmentsTable> {
  $$CachedEnrollmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get academicYearId => $composableBuilder(
    column: $table.academicYearId,
    builder: (column) => column,
  );
}

class $$CachedEnrollmentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedEnrollmentsTable,
          CachedEnrollment,
          $$CachedEnrollmentsTableFilterComposer,
          $$CachedEnrollmentsTableOrderingComposer,
          $$CachedEnrollmentsTableAnnotationComposer,
          $$CachedEnrollmentsTableCreateCompanionBuilder,
          $$CachedEnrollmentsTableUpdateCompanionBuilder,
          (
            CachedEnrollment,
            BaseReferences<
              _$LocalDatabase,
              $CachedEnrollmentsTable,
              CachedEnrollment
            >,
          ),
          CachedEnrollment,
          PrefetchHooks Function()
        > {
  $$CachedEnrollmentsTableTableManager(
    _$LocalDatabase db,
    $CachedEnrollmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedEnrollmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedEnrollmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedEnrollmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<String> academicYearId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedEnrollmentsCompanion(
                id: id,
                studentId: studentId,
                sectionId: sectionId,
                academicYearId: academicYearId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String sectionId,
                required String academicYearId,
                Value<int> rowid = const Value.absent(),
              }) => CachedEnrollmentsCompanion.insert(
                id: id,
                studentId: studentId,
                sectionId: sectionId,
                academicYearId: academicYearId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedEnrollmentsTable, CachedEnrollment>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedEnrollmentsTable,
                    CachedEnrollment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedEnrollmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedEnrollmentsTable,
      CachedEnrollment,
      $$CachedEnrollmentsTableFilterComposer,
      $$CachedEnrollmentsTableOrderingComposer,
      $$CachedEnrollmentsTableAnnotationComposer,
      $$CachedEnrollmentsTableCreateCompanionBuilder,
      $$CachedEnrollmentsTableUpdateCompanionBuilder,
      (
        CachedEnrollment,
        BaseReferences<
          _$LocalDatabase,
          $CachedEnrollmentsTable,
          CachedEnrollment
        >,
      ),
      CachedEnrollment,
      PrefetchHooks Function()
    >;
typedef $$CachedScheduleTableCreateCompanionBuilder =
    CachedScheduleCompanion Function({
      required String id,
      required String sectionId,
      required String sectionName,
      required String subjectId,
      required String subjectName,
      Value<String> teacherName,
      required int dayOfWeek,
      required String startTime,
      required String endTime,
      Value<String?> room,
      Value<int> rowid,
    });
typedef $$CachedScheduleTableUpdateCompanionBuilder =
    CachedScheduleCompanion Function({
      Value<String> id,
      Value<String> sectionId,
      Value<String> sectionName,
      Value<String> subjectId,
      Value<String> subjectName,
      Value<String> teacherName,
      Value<int> dayOfWeek,
      Value<String> startTime,
      Value<String> endTime,
      Value<String?> room,
      Value<int> rowid,
    });

class $$CachedScheduleTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedScheduleTable> {
  $$CachedScheduleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedScheduleTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedScheduleTable> {
  $$CachedScheduleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedScheduleTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedScheduleTable> {
  $$CachedScheduleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);
}

class $$CachedScheduleTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedScheduleTable,
          CachedScheduleData,
          $$CachedScheduleTableFilterComposer,
          $$CachedScheduleTableOrderingComposer,
          $$CachedScheduleTableAnnotationComposer,
          $$CachedScheduleTableCreateCompanionBuilder,
          $$CachedScheduleTableUpdateCompanionBuilder,
          (
            CachedScheduleData,
            BaseReferences<
              _$LocalDatabase,
              $CachedScheduleTable,
              CachedScheduleData
            >,
          ),
          CachedScheduleData,
          PrefetchHooks Function()
        > {
  $$CachedScheduleTableTableManager(
    _$LocalDatabase db,
    $CachedScheduleTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedScheduleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedScheduleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedScheduleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<String> sectionName = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> subjectName = const Value.absent(),
                Value<String> teacherName = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedScheduleCompanion(
                id: id,
                sectionId: sectionId,
                sectionName: sectionName,
                subjectId: subjectId,
                subjectName: subjectName,
                teacherName: teacherName,
                dayOfWeek: dayOfWeek,
                startTime: startTime,
                endTime: endTime,
                room: room,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sectionId,
                required String sectionName,
                required String subjectId,
                required String subjectName,
                Value<String> teacherName = const Value.absent(),
                required int dayOfWeek,
                required String startTime,
                required String endTime,
                Value<String?> room = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedScheduleCompanion.insert(
                id: id,
                sectionId: sectionId,
                sectionName: sectionName,
                subjectId: subjectId,
                subjectName: subjectName,
                teacherName: teacherName,
                dayOfWeek: dayOfWeek,
                startTime: startTime,
                endTime: endTime,
                room: room,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedScheduleTable, CachedScheduleData>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedScheduleTable,
                    CachedScheduleData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedScheduleTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedScheduleTable,
      CachedScheduleData,
      $$CachedScheduleTableFilterComposer,
      $$CachedScheduleTableOrderingComposer,
      $$CachedScheduleTableAnnotationComposer,
      $$CachedScheduleTableCreateCompanionBuilder,
      $$CachedScheduleTableUpdateCompanionBuilder,
      (
        CachedScheduleData,
        BaseReferences<
          _$LocalDatabase,
          $CachedScheduleTable,
          CachedScheduleData
        >,
      ),
      CachedScheduleData,
      PrefetchHooks Function()
    >;
typedef $$AttendanceMarksTableCreateCompanionBuilder =
    AttendanceMarksCompanion Function({
      required String sectionId,
      required String date,
      required String studentId,
      required String enrollmentId,
      Value<String?> serverStatus,
      Value<String?> serverRemarks,
      Value<String?> serverUpdatedAt,
      Value<String?> localStatus,
      Value<String?> localRemarks,
      Value<String?> baseUpdatedAt,
      Value<bool> dirty,
      Value<bool> conflict,
      Value<int> rowid,
    });
typedef $$AttendanceMarksTableUpdateCompanionBuilder =
    AttendanceMarksCompanion Function({
      Value<String> sectionId,
      Value<String> date,
      Value<String> studentId,
      Value<String> enrollmentId,
      Value<String?> serverStatus,
      Value<String?> serverRemarks,
      Value<String?> serverUpdatedAt,
      Value<String?> localStatus,
      Value<String?> localRemarks,
      Value<String?> baseUpdatedAt,
      Value<bool> dirty,
      Value<bool> conflict,
      Value<int> rowid,
    });

class $$AttendanceMarksTableFilterComposer
    extends Composer<_$LocalDatabase, $AttendanceMarksTable> {
  $$AttendanceMarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enrollmentId => $composableBuilder(
    column: $table.enrollmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverStatus => $composableBuilder(
    column: $table.serverStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverRemarks => $composableBuilder(
    column: $table.serverRemarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localRemarks => $composableBuilder(
    column: $table.localRemarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get conflict => $composableBuilder(
    column: $table.conflict,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendanceMarksTableOrderingComposer
    extends Composer<_$LocalDatabase, $AttendanceMarksTable> {
  $$AttendanceMarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enrollmentId => $composableBuilder(
    column: $table.enrollmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverStatus => $composableBuilder(
    column: $table.serverStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverRemarks => $composableBuilder(
    column: $table.serverRemarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localRemarks => $composableBuilder(
    column: $table.localRemarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get conflict => $composableBuilder(
    column: $table.conflict,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendanceMarksTableAnnotationComposer
    extends Composer<_$LocalDatabase, $AttendanceMarksTable> {
  $$AttendanceMarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get enrollmentId => $composableBuilder(
    column: $table.enrollmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverStatus => $composableBuilder(
    column: $table.serverStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverRemarks => $composableBuilder(
    column: $table.serverRemarks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localRemarks => $composableBuilder(
    column: $table.localRemarks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<bool> get conflict =>
      $composableBuilder(column: $table.conflict, builder: (column) => column);
}

class $$AttendanceMarksTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $AttendanceMarksTable,
          AttendanceMark,
          $$AttendanceMarksTableFilterComposer,
          $$AttendanceMarksTableOrderingComposer,
          $$AttendanceMarksTableAnnotationComposer,
          $$AttendanceMarksTableCreateCompanionBuilder,
          $$AttendanceMarksTableUpdateCompanionBuilder,
          (
            AttendanceMark,
            BaseReferences<
              _$LocalDatabase,
              $AttendanceMarksTable,
              AttendanceMark
            >,
          ),
          AttendanceMark,
          PrefetchHooks Function()
        > {
  $$AttendanceMarksTableTableManager(
    _$LocalDatabase db,
    $AttendanceMarksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceMarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceMarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceMarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sectionId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> enrollmentId = const Value.absent(),
                Value<String?> serverStatus = const Value.absent(),
                Value<String?> serverRemarks = const Value.absent(),
                Value<String?> serverUpdatedAt = const Value.absent(),
                Value<String?> localStatus = const Value.absent(),
                Value<String?> localRemarks = const Value.absent(),
                Value<String?> baseUpdatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> conflict = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceMarksCompanion(
                sectionId: sectionId,
                date: date,
                studentId: studentId,
                enrollmentId: enrollmentId,
                serverStatus: serverStatus,
                serverRemarks: serverRemarks,
                serverUpdatedAt: serverUpdatedAt,
                localStatus: localStatus,
                localRemarks: localRemarks,
                baseUpdatedAt: baseUpdatedAt,
                dirty: dirty,
                conflict: conflict,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sectionId,
                required String date,
                required String studentId,
                required String enrollmentId,
                Value<String?> serverStatus = const Value.absent(),
                Value<String?> serverRemarks = const Value.absent(),
                Value<String?> serverUpdatedAt = const Value.absent(),
                Value<String?> localStatus = const Value.absent(),
                Value<String?> localRemarks = const Value.absent(),
                Value<String?> baseUpdatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> conflict = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceMarksCompanion.insert(
                sectionId: sectionId,
                date: date,
                studentId: studentId,
                enrollmentId: enrollmentId,
                serverStatus: serverStatus,
                serverRemarks: serverRemarks,
                serverUpdatedAt: serverUpdatedAt,
                localStatus: localStatus,
                localRemarks: localRemarks,
                baseUpdatedAt: baseUpdatedAt,
                dirty: dirty,
                conflict: conflict,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttendanceMarksTable, AttendanceMark>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $AttendanceMarksTable,
                    AttendanceMark
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendanceMarksTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $AttendanceMarksTable,
      AttendanceMark,
      $$AttendanceMarksTableFilterComposer,
      $$AttendanceMarksTableOrderingComposer,
      $$AttendanceMarksTableAnnotationComposer,
      $$AttendanceMarksTableCreateCompanionBuilder,
      $$AttendanceMarksTableUpdateCompanionBuilder,
      (
        AttendanceMark,
        BaseReferences<_$LocalDatabase, $AttendanceMarksTable, AttendanceMark>,
      ),
      AttendanceMark,
      PrefetchHooks Function()
    >;
typedef $$CachedGradesTableCreateCompanionBuilder =
    CachedGradesCompanion Function({
      required String id,
      required String studentId,
      required String sectionId,
      required String subjectName,
      required String periodName,
      Value<int> periodSequence,
      Value<String?> score,
      required String status,
      Value<int> rowid,
    });
typedef $$CachedGradesTableUpdateCompanionBuilder =
    CachedGradesCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> sectionId,
      Value<String> subjectName,
      Value<String> periodName,
      Value<int> periodSequence,
      Value<String?> score,
      Value<String> status,
      Value<int> rowid,
    });

class $$CachedGradesTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedGradesTable> {
  $$CachedGradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodName => $composableBuilder(
    column: $table.periodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodSequence => $composableBuilder(
    column: $table.periodSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedGradesTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedGradesTable> {
  $$CachedGradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodName => $composableBuilder(
    column: $table.periodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodSequence => $composableBuilder(
    column: $table.periodSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedGradesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedGradesTable> {
  $$CachedGradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get periodName => $composableBuilder(
    column: $table.periodName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodSequence => $composableBuilder(
    column: $table.periodSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CachedGradesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedGradesTable,
          CachedGrade,
          $$CachedGradesTableFilterComposer,
          $$CachedGradesTableOrderingComposer,
          $$CachedGradesTableAnnotationComposer,
          $$CachedGradesTableCreateCompanionBuilder,
          $$CachedGradesTableUpdateCompanionBuilder,
          (
            CachedGrade,
            BaseReferences<_$LocalDatabase, $CachedGradesTable, CachedGrade>,
          ),
          CachedGrade,
          PrefetchHooks Function()
        > {
  $$CachedGradesTableTableManager(_$LocalDatabase db, $CachedGradesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedGradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedGradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedGradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<String> subjectName = const Value.absent(),
                Value<String> periodName = const Value.absent(),
                Value<int> periodSequence = const Value.absent(),
                Value<String?> score = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedGradesCompanion(
                id: id,
                studentId: studentId,
                sectionId: sectionId,
                subjectName: subjectName,
                periodName: periodName,
                periodSequence: periodSequence,
                score: score,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String sectionId,
                required String subjectName,
                required String periodName,
                Value<int> periodSequence = const Value.absent(),
                Value<String?> score = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => CachedGradesCompanion.insert(
                id: id,
                studentId: studentId,
                sectionId: sectionId,
                subjectName: subjectName,
                periodName: periodName,
                periodSequence: periodSequence,
                score: score,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedGradesTable, CachedGrade>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedGradesTable,
                    CachedGrade
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedGradesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedGradesTable,
      CachedGrade,
      $$CachedGradesTableFilterComposer,
      $$CachedGradesTableOrderingComposer,
      $$CachedGradesTableAnnotationComposer,
      $$CachedGradesTableCreateCompanionBuilder,
      $$CachedGradesTableUpdateCompanionBuilder,
      (
        CachedGrade,
        BaseReferences<_$LocalDatabase, $CachedGradesTable, CachedGrade>,
      ),
      CachedGrade,
      PrefetchHooks Function()
    >;
typedef $$CachedAssignmentsTableCreateCompanionBuilder =
    CachedAssignmentsCompanion Function({
      required String id,
      required String sectionId,
      required String sectionName,
      required String subjectName,
      Value<String> teacherName,
      required String title,
      Value<String?> description,
      Value<DateTime?> dueAt,
      required String status,
      Value<int> rowid,
    });
typedef $$CachedAssignmentsTableUpdateCompanionBuilder =
    CachedAssignmentsCompanion Function({
      Value<String> id,
      Value<String> sectionId,
      Value<String> sectionName,
      Value<String> subjectName,
      Value<String> teacherName,
      Value<String> title,
      Value<String?> description,
      Value<DateTime?> dueAt,
      Value<String> status,
      Value<int> rowid,
    });

class $$CachedAssignmentsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedAssignmentsTable> {
  $$CachedAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAssignmentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedAssignmentsTable> {
  $$CachedAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAssignmentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedAssignmentsTable> {
  $$CachedAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CachedAssignmentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedAssignmentsTable,
          CachedAssignment,
          $$CachedAssignmentsTableFilterComposer,
          $$CachedAssignmentsTableOrderingComposer,
          $$CachedAssignmentsTableAnnotationComposer,
          $$CachedAssignmentsTableCreateCompanionBuilder,
          $$CachedAssignmentsTableUpdateCompanionBuilder,
          (
            CachedAssignment,
            BaseReferences<
              _$LocalDatabase,
              $CachedAssignmentsTable,
              CachedAssignment
            >,
          ),
          CachedAssignment,
          PrefetchHooks Function()
        > {
  $$CachedAssignmentsTableTableManager(
    _$LocalDatabase db,
    $CachedAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<String> sectionName = const Value.absent(),
                Value<String> subjectName = const Value.absent(),
                Value<String> teacherName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssignmentsCompanion(
                id: id,
                sectionId: sectionId,
                sectionName: sectionName,
                subjectName: subjectName,
                teacherName: teacherName,
                title: title,
                description: description,
                dueAt: dueAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sectionId,
                required String sectionName,
                required String subjectName,
                Value<String> teacherName = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => CachedAssignmentsCompanion.insert(
                id: id,
                sectionId: sectionId,
                sectionName: sectionName,
                subjectName: subjectName,
                teacherName: teacherName,
                title: title,
                description: description,
                dueAt: dueAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedAssignmentsTable, CachedAssignment>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedAssignmentsTable,
                    CachedAssignment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedAssignmentsTable,
      CachedAssignment,
      $$CachedAssignmentsTableFilterComposer,
      $$CachedAssignmentsTableOrderingComposer,
      $$CachedAssignmentsTableAnnotationComposer,
      $$CachedAssignmentsTableCreateCompanionBuilder,
      $$CachedAssignmentsTableUpdateCompanionBuilder,
      (
        CachedAssignment,
        BaseReferences<
          _$LocalDatabase,
          $CachedAssignmentsTable,
          CachedAssignment
        >,
      ),
      CachedAssignment,
      PrefetchHooks Function()
    >;
typedef $$CachedChargesTableCreateCompanionBuilder =
    CachedChargesCompanion Function({
      required String id,
      required String studentId,
      required String description,
      Value<String?> dueDate,
      required String netAmount,
      required String paid,
      required String remaining,
      required String status,
      Value<int> rowid,
    });
typedef $$CachedChargesTableUpdateCompanionBuilder =
    CachedChargesCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> description,
      Value<String?> dueDate,
      Value<String> netAmount,
      Value<String> paid,
      Value<String> remaining,
      Value<String> status,
      Value<int> rowid,
    });

class $$CachedChargesTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedChargesTable> {
  $$CachedChargesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get netAmount => $composableBuilder(
    column: $table.netAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedChargesTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedChargesTable> {
  $$CachedChargesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get netAmount => $composableBuilder(
    column: $table.netAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedChargesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedChargesTable> {
  $$CachedChargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get netAmount =>
      $composableBuilder(column: $table.netAmount, builder: (column) => column);

  GeneratedColumn<String> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<String> get remaining =>
      $composableBuilder(column: $table.remaining, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CachedChargesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedChargesTable,
          CachedCharge,
          $$CachedChargesTableFilterComposer,
          $$CachedChargesTableOrderingComposer,
          $$CachedChargesTableAnnotationComposer,
          $$CachedChargesTableCreateCompanionBuilder,
          $$CachedChargesTableUpdateCompanionBuilder,
          (
            CachedCharge,
            BaseReferences<_$LocalDatabase, $CachedChargesTable, CachedCharge>,
          ),
          CachedCharge,
          PrefetchHooks Function()
        > {
  $$CachedChargesTableTableManager(
    _$LocalDatabase db,
    $CachedChargesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedChargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedChargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedChargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String> netAmount = const Value.absent(),
                Value<String> paid = const Value.absent(),
                Value<String> remaining = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChargesCompanion(
                id: id,
                studentId: studentId,
                description: description,
                dueDate: dueDate,
                netAmount: netAmount,
                paid: paid,
                remaining: remaining,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String description,
                Value<String?> dueDate = const Value.absent(),
                required String netAmount,
                required String paid,
                required String remaining,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => CachedChargesCompanion.insert(
                id: id,
                studentId: studentId,
                description: description,
                dueDate: dueDate,
                netAmount: netAmount,
                paid: paid,
                remaining: remaining,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedChargesTable, CachedCharge>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedChargesTable,
                    CachedCharge
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedChargesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedChargesTable,
      CachedCharge,
      $$CachedChargesTableFilterComposer,
      $$CachedChargesTableOrderingComposer,
      $$CachedChargesTableAnnotationComposer,
      $$CachedChargesTableCreateCompanionBuilder,
      $$CachedChargesTableUpdateCompanionBuilder,
      (
        CachedCharge,
        BaseReferences<_$LocalDatabase, $CachedChargesTable, CachedCharge>,
      ),
      CachedCharge,
      PrefetchHooks Function()
    >;
typedef $$CachedPaymentsTableCreateCompanionBuilder =
    CachedPaymentsCompanion Function({
      required String id,
      required String studentId,
      required String paymentDate,
      required String amount,
      required String currency,
      required String method,
      required String status,
      Value<String?> receiptNumber,
      Value<int> rowid,
    });
typedef $$CachedPaymentsTableUpdateCompanionBuilder =
    CachedPaymentsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> paymentDate,
      Value<String> amount,
      Value<String> currency,
      Value<String> method,
      Value<String> status,
      Value<String?> receiptNumber,
      Value<int> rowid,
    });

class $$CachedPaymentsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedPaymentsTable> {
  $$CachedPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPaymentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedPaymentsTable> {
  $$CachedPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPaymentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedPaymentsTable> {
  $$CachedPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );
}

class $$CachedPaymentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedPaymentsTable,
          CachedPayment,
          $$CachedPaymentsTableFilterComposer,
          $$CachedPaymentsTableOrderingComposer,
          $$CachedPaymentsTableAnnotationComposer,
          $$CachedPaymentsTableCreateCompanionBuilder,
          $$CachedPaymentsTableUpdateCompanionBuilder,
          (
            CachedPayment,
            BaseReferences<
              _$LocalDatabase,
              $CachedPaymentsTable,
              CachedPayment
            >,
          ),
          CachedPayment,
          PrefetchHooks Function()
        > {
  $$CachedPaymentsTableTableManager(
    _$LocalDatabase db,
    $CachedPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> paymentDate = const Value.absent(),
                Value<String> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> receiptNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPaymentsCompanion(
                id: id,
                studentId: studentId,
                paymentDate: paymentDate,
                amount: amount,
                currency: currency,
                method: method,
                status: status,
                receiptNumber: receiptNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String paymentDate,
                required String amount,
                required String currency,
                required String method,
                required String status,
                Value<String?> receiptNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPaymentsCompanion.insert(
                id: id,
                studentId: studentId,
                paymentDate: paymentDate,
                amount: amount,
                currency: currency,
                method: method,
                status: status,
                receiptNumber: receiptNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedPaymentsTable, CachedPayment>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedPaymentsTable,
                    CachedPayment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedPaymentsTable,
      CachedPayment,
      $$CachedPaymentsTableFilterComposer,
      $$CachedPaymentsTableOrderingComposer,
      $$CachedPaymentsTableAnnotationComposer,
      $$CachedPaymentsTableCreateCompanionBuilder,
      $$CachedPaymentsTableUpdateCompanionBuilder,
      (
        CachedPayment,
        BaseReferences<_$LocalDatabase, $CachedPaymentsTable, CachedPayment>,
      ),
      CachedPayment,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String entityType,
  required String entityId,
  required String operation,
  required String payload,
  Value<DateTime> createdAt,
  Value<int> attemptCount,
  Value<DateTime?> lastAttemptAt,
  Value<String> status,
  Value<String?> errorMessage,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> attemptCount,
  Value<DateTime?> lastAttemptAt,
  Value<String> status,
  Value<String?> errorMessage,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$LocalDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$LocalDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$LocalDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$LocalDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastAttemptAt: lastAttemptAt,
                status: status,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastAttemptAt: lastAttemptAt,
                status: status,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueData>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $SyncQueueTable,
                    SyncQueueData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$LocalDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$MetaEntriesTableTableManager get metaEntries =>
      $$MetaEntriesTableTableManager(_db, _db.metaEntries);
  $$CachedNotificationsTableTableManager get cachedNotifications =>
      $$CachedNotificationsTableTableManager(_db, _db.cachedNotifications);
  $$CachedAnnouncementsTableTableManager get cachedAnnouncements =>
      $$CachedAnnouncementsTableTableManager(_db, _db.cachedAnnouncements);
  $$CachedSectionsTableTableManager get cachedSections =>
      $$CachedSectionsTableTableManager(_db, _db.cachedSections);
  $$CachedStudentsTableTableManager get cachedStudents =>
      $$CachedStudentsTableTableManager(_db, _db.cachedStudents);
  $$CachedEnrollmentsTableTableManager get cachedEnrollments =>
      $$CachedEnrollmentsTableTableManager(_db, _db.cachedEnrollments);
  $$CachedScheduleTableTableManager get cachedSchedule =>
      $$CachedScheduleTableTableManager(_db, _db.cachedSchedule);
  $$AttendanceMarksTableTableManager get attendanceMarks =>
      $$AttendanceMarksTableTableManager(_db, _db.attendanceMarks);
  $$CachedGradesTableTableManager get cachedGrades =>
      $$CachedGradesTableTableManager(_db, _db.cachedGrades);
  $$CachedAssignmentsTableTableManager get cachedAssignments =>
      $$CachedAssignmentsTableTableManager(_db, _db.cachedAssignments);
  $$CachedChargesTableTableManager get cachedCharges =>
      $$CachedChargesTableTableManager(_db, _db.cachedCharges);
  $$CachedPaymentsTableTableManager get cachedPayments =>
      $$CachedPaymentsTableTableManager(_db, _db.cachedPayments);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}

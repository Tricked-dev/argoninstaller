// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetInstalledModCollection on Isar {
  IsarCollection<InstalledMod> get installedMods {
    return getCollection('InstalledMod');
  }
}

final InstalledModSchema = CollectionSchema(
  name: 'InstalledMod',
  schema:
      '{"name":"InstalledMod","idName":"id","properties":[{"name":"filename","type":"String"},{"name":"mcv","type":"String"},{"name":"mcversions","type":"StringList"},{"name":"modId","type":"String"},{"name":"repo","type":"String"},{"name":"url","type":"String"},{"name":"version","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _InstalledModNativeAdapter(),
  webAdapter: const _InstalledModWebAdapter(),
  idName: 'id',
  propertyIds: {
    'filename': 0,
    'mcv': 1,
    'mcversions': 2,
    'modId': 3,
    'repo': 4,
    'url': 5,
    'version': 6
  },
  listProperties: {'mcversions'},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

class _InstalledModWebAdapter extends IsarWebTypeAdapter<InstalledMod> {
  const _InstalledModWebAdapter();

  @override
  Object serialize(
      IsarCollection<InstalledMod> collection, InstalledMod object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'filename', object.filename);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'mcv', object.mcv);
    IsarNative.jsObjectSet(jsObj, 'mcversions', object.mcversions);
    IsarNative.jsObjectSet(jsObj, 'modId', object.modId);
    IsarNative.jsObjectSet(jsObj, 'repo', object.repo);
    IsarNative.jsObjectSet(jsObj, 'url', object.url);
    IsarNative.jsObjectSet(jsObj, 'version', object.version);
    return jsObj;
  }

  @override
  InstalledMod deserialize(
      IsarCollection<InstalledMod> collection, dynamic jsObj) {
    final object = InstalledMod();
    object.filename = IsarNative.jsObjectGet(jsObj, 'filename') ?? '';
    object.id = IsarNative.jsObjectGet(jsObj, 'id');
    object.mcv = IsarNative.jsObjectGet(jsObj, 'mcv') ?? '';
    object.mcversions = (IsarNative.jsObjectGet(jsObj, 'mcversions') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>() ??
        [];
    object.modId = IsarNative.jsObjectGet(jsObj, 'modId') ?? '';
    object.repo = IsarNative.jsObjectGet(jsObj, 'repo') ?? '';
    object.url = IsarNative.jsObjectGet(jsObj, 'url') ?? '';
    object.version = IsarNative.jsObjectGet(jsObj, 'version') ?? '';
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'filename':
        return (IsarNative.jsObjectGet(jsObj, 'filename') ?? '') as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'mcv':
        return (IsarNative.jsObjectGet(jsObj, 'mcv') ?? '') as P;
      case 'mcversions':
        return ((IsarNative.jsObjectGet(jsObj, 'mcversions') as List?)
                ?.map((e) => e ?? '')
                .toList()
                .cast<String>() ??
            []) as P;
      case 'modId':
        return (IsarNative.jsObjectGet(jsObj, 'modId') ?? '') as P;
      case 'repo':
        return (IsarNative.jsObjectGet(jsObj, 'repo') ?? '') as P;
      case 'url':
        return (IsarNative.jsObjectGet(jsObj, 'url') ?? '') as P;
      case 'version':
        return (IsarNative.jsObjectGet(jsObj, 'version') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, InstalledMod object) {}
}

class _InstalledModNativeAdapter extends IsarNativeTypeAdapter<InstalledMod> {
  const _InstalledModNativeAdapter();

  @override
  void serialize(
      IsarCollection<InstalledMod> collection,
      IsarRawObject rawObj,
      InstalledMod object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.filename;
    final _filename = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_filename.length) as int;
    final value1 = object.mcv;
    final _mcv = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_mcv.length) as int;
    final value2 = object.mcversions;
    dynamicSize += (value2.length) * 8;
    final bytesList2 = <IsarUint8List>[];
    for (var str in value2) {
      final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
      bytesList2.add(bytes);
      dynamicSize += bytes.length as int;
    }
    final _mcversions = bytesList2;
    final value3 = object.modId;
    final _modId = IsarBinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += (_modId.length) as int;
    final value4 = object.repo;
    final _repo = IsarBinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += (_repo.length) as int;
    final value5 = object.url;
    final _url = IsarBinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += (_url.length) as int;
    final value6 = object.version;
    final _version = IsarBinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += (_version.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _filename);
    writer.writeBytes(offsets[1], _mcv);
    writer.writeStringList(offsets[2], _mcversions);
    writer.writeBytes(offsets[3], _modId);
    writer.writeBytes(offsets[4], _repo);
    writer.writeBytes(offsets[5], _url);
    writer.writeBytes(offsets[6], _version);
  }

  @override
  InstalledMod deserialize(IsarCollection<InstalledMod> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = InstalledMod();
    object.filename = reader.readString(offsets[0]);
    object.id = id;
    object.mcv = reader.readString(offsets[1]);
    object.mcversions = reader.readStringList(offsets[2]) ?? [];
    object.modId = reader.readString(offsets[3]);
    object.repo = reader.readString(offsets[4]);
    object.url = reader.readString(offsets[5]);
    object.version = reader.readString(offsets[6]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readStringList(offset) ?? []) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, InstalledMod object) {}
}

extension InstalledModQueryWhereSort
    on QueryBuilder<InstalledMod, InstalledMod, QWhere> {
  QueryBuilder<InstalledMod, InstalledMod, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension InstalledModQueryWhere
    on QueryBuilder<InstalledMod, InstalledMod, QWhereClause> {
  QueryBuilder<InstalledMod, InstalledMod, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterWhereClause> idNotEqualTo(
      int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension InstalledModQueryFilter
    on QueryBuilder<InstalledMod, InstalledMod, QFilterCondition> {
  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'filename',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'filename',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'filename',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'filename',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'filename',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'filename',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'filename',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      filenameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'filename',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'mcv',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcvGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'mcv',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'mcv',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'mcv',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'mcv',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'mcv',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'mcv',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> mcvMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'mcv',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'mcversions',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'mcversions',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'mcversions',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'mcversions',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'mcversions',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'mcversions',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'mcversions',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      mcversionsAnyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'mcversions',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> modIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'modId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      modIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'modId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> modIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'modId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> modIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'modId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      modIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'modId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> modIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'modId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> modIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'modId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> modIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'modId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> repoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'repo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      repoGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'repo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> repoLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'repo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> repoBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'repo',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      repoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'repo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> repoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'repo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> repoContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'repo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> repoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'repo',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'url',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      urlGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'url',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'url',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'url',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'url',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'url',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'url',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'url',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'version',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'version',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'version',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'version',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'version',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'version',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'version',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterFilterCondition>
      versionMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'version',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension InstalledModQueryLinks
    on QueryBuilder<InstalledMod, InstalledMod, QFilterCondition> {}

extension InstalledModQueryWhereSortBy
    on QueryBuilder<InstalledMod, InstalledMod, QSortBy> {
  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByFilename() {
    return addSortByInternal('filename', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByFilenameDesc() {
    return addSortByInternal('filename', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByMcv() {
    return addSortByInternal('mcv', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByMcvDesc() {
    return addSortByInternal('mcv', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByModId() {
    return addSortByInternal('modId', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByModIdDesc() {
    return addSortByInternal('modId', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByRepo() {
    return addSortByInternal('repo', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByRepoDesc() {
    return addSortByInternal('repo', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByUrl() {
    return addSortByInternal('url', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByUrlDesc() {
    return addSortByInternal('url', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByVersion() {
    return addSortByInternal('version', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> sortByVersionDesc() {
    return addSortByInternal('version', Sort.desc);
  }
}

extension InstalledModQueryWhereSortThenBy
    on QueryBuilder<InstalledMod, InstalledMod, QSortThenBy> {
  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByFilename() {
    return addSortByInternal('filename', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByFilenameDesc() {
    return addSortByInternal('filename', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByMcv() {
    return addSortByInternal('mcv', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByMcvDesc() {
    return addSortByInternal('mcv', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByModId() {
    return addSortByInternal('modId', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByModIdDesc() {
    return addSortByInternal('modId', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByRepo() {
    return addSortByInternal('repo', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByRepoDesc() {
    return addSortByInternal('repo', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByUrl() {
    return addSortByInternal('url', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByUrlDesc() {
    return addSortByInternal('url', Sort.desc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByVersion() {
    return addSortByInternal('version', Sort.asc);
  }

  QueryBuilder<InstalledMod, InstalledMod, QAfterSortBy> thenByVersionDesc() {
    return addSortByInternal('version', Sort.desc);
  }
}

extension InstalledModQueryWhereDistinct
    on QueryBuilder<InstalledMod, InstalledMod, QDistinct> {
  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctByFilename(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('filename', caseSensitive: caseSensitive);
  }

  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctByMcv(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('mcv', caseSensitive: caseSensitive);
  }

  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctByModId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('modId', caseSensitive: caseSensitive);
  }

  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctByRepo(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('repo', caseSensitive: caseSensitive);
  }

  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('url', caseSensitive: caseSensitive);
  }

  QueryBuilder<InstalledMod, InstalledMod, QDistinct> distinctByVersion(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('version', caseSensitive: caseSensitive);
  }
}

extension InstalledModQueryProperty
    on QueryBuilder<InstalledMod, InstalledMod, QQueryProperty> {
  QueryBuilder<InstalledMod, String, QQueryOperations> filenameProperty() {
    return addPropertyNameInternal('filename');
  }

  QueryBuilder<InstalledMod, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<InstalledMod, String, QQueryOperations> mcvProperty() {
    return addPropertyNameInternal('mcv');
  }

  QueryBuilder<InstalledMod, List<String>, QQueryOperations>
      mcversionsProperty() {
    return addPropertyNameInternal('mcversions');
  }

  QueryBuilder<InstalledMod, String, QQueryOperations> modIdProperty() {
    return addPropertyNameInternal('modId');
  }

  QueryBuilder<InstalledMod, String, QQueryOperations> repoProperty() {
    return addPropertyNameInternal('repo');
  }

  QueryBuilder<InstalledMod, String, QQueryOperations> urlProperty() {
    return addPropertyNameInternal('url');
  }

  QueryBuilder<InstalledMod, String, QQueryOperations> versionProperty() {
    return addPropertyNameInternal('version');
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadMod _$DownloadModFromJson(Map<String, dynamic> json) => DownloadMod(
      mcversions: (json['mcversions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      version: json['version'] as String,
      hash: json['hash'] as String,
      url: json['url'] as String,
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$DownloadModToJson(DownloadMod instance) =>
    <String, dynamic>{
      'mcversions': instance.mcversions,
      'version': instance.version,
      'hash': instance.hash,
      'url': instance.url,
      'filename': instance.filename,
    };

Mod _$ModFromJson(Map<String, dynamic> json) => Mod(
      repo: json['repo'] as String,
      id: json['id'] as String,
      nicknames:
          (json['nicknames'] as List<dynamic>).map((e) => e as String).toList(),
      forgeid: json['forgeid'] as String,
      display: json['display'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      conflicts:
          (json['conflicts'] as List<dynamic>).map((e) => e as String).toList(),
      meta: Map<String, String>.from(json['meta'] as Map),
      downloads: (json['downloads'] as List<dynamic>)
          .map((e) => DownloadMod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModToJson(Mod instance) => <String, dynamic>{
      'repo': instance.repo,
      'id': instance.id,
      'nicknames': instance.nicknames,
      'forgeid': instance.forgeid,
      'display': instance.display,
      'description': instance.description,
      'icon': instance.icon,
      'categories': instance.categories,
      'conflicts': instance.conflicts,
      'meta': instance.meta,
      'downloads': instance.downloads,
    };

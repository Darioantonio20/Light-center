// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTreatmentCollection on Isar {
  IsarCollection<Treatment> get treatments => this.collection();
}

const TreatmentSchema = CollectionSchema(
  name: r'Treatment',
  id: -2494921379818073871,
  properties: {
    r'appointmentsPerWeek': PropertySchema(
      id: 0,
      name: r'appointmentsPerWeek',
      type: IsarType.long,
    ),
    r'availableAppointments': PropertySchema(
      id: 1,
      name: r'availableAppointments',
      type: IsarType.long,
    ),
    r'firstDateToSchedule': PropertySchema(
      id: 2,
      name: r'firstDateToSchedule',
      type: IsarType.dateTime,
    ),
    r'lastDateToSchedule': PropertySchema(
      id: 3,
      name: r'lastDateToSchedule',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'orderId': PropertySchema(
      id: 5,
      name: r'orderId',
      type: IsarType.long,
    ),
    r'productId': PropertySchema(
      id: 6,
      name: r'productId',
      type: IsarType.long,
    ),
    r'scheduledAppointments': PropertySchema(
      id: 7,
      name: r'scheduledAppointments',
      type: IsarType.stringList,
    )
  },
  estimateSize: _treatmentEstimateSize,
  serialize: _treatmentSerialize,
  deserialize: _treatmentDeserialize,
  deserializeProp: _treatmentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'user': LinkSchema(
      id: 183272576202861209,
      name: r'user',
      target: r'User',
      single: true,
      linkName: r'treatments',
    )
  },
  embeddedSchemas: {},
  getId: _treatmentGetId,
  getLinks: _treatmentGetLinks,
  attach: _treatmentAttach,
  version: '3.1.0+1',
);

int _treatmentEstimateSize(
  Treatment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.scheduledAppointments;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _treatmentSerialize(
  Treatment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.appointmentsPerWeek);
  writer.writeLong(offsets[1], object.availableAppointments);
  writer.writeDateTime(offsets[2], object.firstDateToSchedule);
  writer.writeDateTime(offsets[3], object.lastDateToSchedule);
  writer.writeString(offsets[4], object.name);
  writer.writeLong(offsets[5], object.orderId);
  writer.writeLong(offsets[6], object.productId);
  writer.writeStringList(offsets[7], object.scheduledAppointments);
}

Treatment _treatmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Treatment();
  object.appointmentsPerWeek = reader.readLongOrNull(offsets[0]);
  object.availableAppointments = reader.readLongOrNull(offsets[1]);
  object.firstDateToSchedule = reader.readDateTimeOrNull(offsets[2]);
  object.id = id;
  object.lastDateToSchedule = reader.readDateTimeOrNull(offsets[3]);
  object.name = reader.readStringOrNull(offsets[4]);
  object.orderId = reader.readLongOrNull(offsets[5]);
  object.productId = reader.readLongOrNull(offsets[6]);
  object.scheduledAppointments = reader.readStringList(offsets[7]);
  return object;
}

P _treatmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _treatmentGetId(Treatment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _treatmentGetLinks(Treatment object) {
  return [object.user];
}

void _treatmentAttach(IsarCollection<dynamic> col, Id id, Treatment object) {
  object.id = id;
  object.user.attach(col, col.isar.collection<User>(), r'user', id);
}

extension TreatmentQueryWhereSort
    on QueryBuilder<Treatment, Treatment, QWhere> {
  QueryBuilder<Treatment, Treatment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TreatmentQueryWhere
    on QueryBuilder<Treatment, Treatment, QWhereClause> {
  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TreatmentQueryFilter
    on QueryBuilder<Treatment, Treatment, QFilterCondition> {
  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      appointmentsPerWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appointmentsPerWeek',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      appointmentsPerWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appointmentsPerWeek',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      appointmentsPerWeekEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appointmentsPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      appointmentsPerWeekGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appointmentsPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      appointmentsPerWeekLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appointmentsPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      appointmentsPerWeekBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appointmentsPerWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'availableAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'availableAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableAppointments',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableAppointments',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableAppointments',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableAppointments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstDateToSchedule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDateToSchedule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      productIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      productIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAppointments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAppointments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAppointments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAppointments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduledAppointments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduledAppointments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduledAppointments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduledAppointments',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAppointments',
        value: '',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduledAppointments',
        value: '',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension TreatmentQueryObject
    on QueryBuilder<Treatment, Treatment, QFilterCondition> {}

extension TreatmentQueryLinks
    on QueryBuilder<Treatment, Treatment, QFilterCondition> {
  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> user(
      FilterQuery<User> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'user');
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'user', 0, true, 0, true);
    });
  }
}

extension TreatmentQuerySortBy on QueryBuilder<Treatment, Treatment, QSortBy> {
  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByAppointmentsPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appointmentsPerWeek', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByAppointmentsPerWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appointmentsPerWeek', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByAvailableAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByAvailableAppointmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByFirstDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByFirstDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByLastDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByLastDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }
}

extension TreatmentQuerySortThenBy
    on QueryBuilder<Treatment, Treatment, QSortThenBy> {
  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByAppointmentsPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appointmentsPerWeek', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByAppointmentsPerWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appointmentsPerWeek', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByAvailableAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByAvailableAppointmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByFirstDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByFirstDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByLastDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByLastDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }
}

extension TreatmentQueryWhereDistinct
    on QueryBuilder<Treatment, Treatment, QDistinct> {
  QueryBuilder<Treatment, Treatment, QDistinct>
      distinctByAppointmentsPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appointmentsPerWeek');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct>
      distinctByAvailableAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'availableAppointments');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct>
      distinctByFirstDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstDateToSchedule');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByLastDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDateToSchedule');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct>
      distinctByScheduledAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAppointments');
    });
  }
}

extension TreatmentQueryProperty
    on QueryBuilder<Treatment, Treatment, QQueryProperty> {
  QueryBuilder<Treatment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations>
      appointmentsPerWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appointmentsPerWeek');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations>
      availableAppointmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableAppointments');
    });
  }

  QueryBuilder<Treatment, DateTime?, QQueryOperations>
      firstDateToScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDateToSchedule');
    });
  }

  QueryBuilder<Treatment, DateTime?, QQueryOperations>
      lastDateToScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDateToSchedule');
    });
  }

  QueryBuilder<Treatment, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations> orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<Treatment, List<String>?, QQueryOperations>
      scheduledAppointmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAppointments');
    });
  }
}

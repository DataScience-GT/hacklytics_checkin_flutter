/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Event type in your schema. */
class Event extends amplify_core.Model {
  static const classType = const _EventModelType();
  final String id;
  final String? _name;
  final String? _description;
  final bool? _status;
  final bool? _requireRSVP;
  final bool? _canRSVP;
  final amplify_core.TemporalDateTime? _start;
  final amplify_core.TemporalDateTime? _end;
  final String? _location;
  final int? _points;
  final List<Checkin>? _checkins;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get description {
    return _description;
  }
  
  bool? get status {
    return _status;
  }
  
  bool? get requireRSVP {
    return _requireRSVP;
  }
  
  bool? get canRSVP {
    return _canRSVP;
  }
  
  amplify_core.TemporalDateTime? get start {
    return _start;
  }
  
  amplify_core.TemporalDateTime? get end {
    return _end;
  }
  
  String? get location {
    return _location;
  }
  
  int? get points {
    return _points;
  }
  
  List<Checkin>? get checkins {
    return _checkins;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Event._internal({required this.id, required name, description, status, requireRSVP, canRSVP, start, end, location, points, checkins, createdAt, updatedAt}): _name = name, _description = description, _status = status, _requireRSVP = requireRSVP, _canRSVP = canRSVP, _start = start, _end = end, _location = location, _points = points, _checkins = checkins, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Event({String? id, required String name, String? description, bool? status, bool? requireRSVP, bool? canRSVP, amplify_core.TemporalDateTime? start, amplify_core.TemporalDateTime? end, String? location, int? points, List<Checkin>? checkins}) {
    return Event._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      description: description,
      status: status,
      requireRSVP: requireRSVP,
      canRSVP: canRSVP,
      start: start,
      end: end,
      location: location,
      points: points,
      checkins: checkins != null ? List<Checkin>.unmodifiable(checkins) : checkins);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Event &&
      id == other.id &&
      _name == other._name &&
      _description == other._description &&
      _status == other._status &&
      _requireRSVP == other._requireRSVP &&
      _canRSVP == other._canRSVP &&
      _start == other._start &&
      _end == other._end &&
      _location == other._location &&
      _points == other._points &&
      DeepCollectionEquality().equals(_checkins, other._checkins);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Event {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("status=" + (_status != null ? _status!.toString() : "null") + ", ");
    buffer.write("requireRSVP=" + (_requireRSVP != null ? _requireRSVP!.toString() : "null") + ", ");
    buffer.write("canRSVP=" + (_canRSVP != null ? _canRSVP!.toString() : "null") + ", ");
    buffer.write("start=" + (_start != null ? _start!.format() : "null") + ", ");
    buffer.write("end=" + (_end != null ? _end!.format() : "null") + ", ");
    buffer.write("location=" + "$_location" + ", ");
    buffer.write("points=" + (_points != null ? _points!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Event copyWith({String? id, String? name, String? description, bool? status, bool? requireRSVP, bool? canRSVP, amplify_core.TemporalDateTime? start, amplify_core.TemporalDateTime? end, String? location, int? points, List<Checkin>? checkins}) {
    return Event._internal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      requireRSVP: requireRSVP ?? this.requireRSVP,
      canRSVP: canRSVP ?? this.canRSVP,
      start: start ?? this.start,
      end: end ?? this.end,
      location: location ?? this.location,
      points: points ?? this.points,
      checkins: checkins ?? this.checkins);
  }
  
  Event copyWithModelFieldValues({
    ModelFieldValue<String>? id,
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? description,
    ModelFieldValue<bool?>? status,
    ModelFieldValue<bool?>? requireRSVP,
    ModelFieldValue<bool?>? canRSVP,
    ModelFieldValue<amplify_core.TemporalDateTime?>? start,
    ModelFieldValue<amplify_core.TemporalDateTime?>? end,
    ModelFieldValue<String?>? location,
    ModelFieldValue<int?>? points,
    ModelFieldValue<List<Checkin>?>? checkins
  }) {
    return Event._internal(
      id: id == null ? this.id : id.value,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      status: status == null ? this.status : status.value,
      requireRSVP: requireRSVP == null ? this.requireRSVP : requireRSVP.value,
      canRSVP: canRSVP == null ? this.canRSVP : canRSVP.value,
      start: start == null ? this.start : start.value,
      end: end == null ? this.end : end.value,
      location: location == null ? this.location : location.value,
      points: points == null ? this.points : points.value,
      checkins: checkins == null ? this.checkins : checkins.value
    );
  }
  
  Event.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _description = json['description'],
      _status = json['status'],
      _requireRSVP = json['requireRSVP'],
      _canRSVP = json['canRSVP'],
      _start = json['start'] != null ? amplify_core.TemporalDateTime.fromString(json['start']) : null,
      _end = json['end'] != null ? amplify_core.TemporalDateTime.fromString(json['end']) : null,
      _location = json['location'],
      _points = (json['points'] as num?)?.toInt(),
      _checkins = json['checkins'] is List
        ? (json['checkins'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Checkin.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'description': _description, 'status': _status, 'requireRSVP': _requireRSVP, 'canRSVP': _canRSVP, 'start': _start?.format(), 'end': _end?.format(), 'location': _location, 'points': _points, 'checkins': _checkins?.map((Checkin? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'description': _description,
    'status': _status,
    'requireRSVP': _requireRSVP,
    'canRSVP': _canRSVP,
    'start': _start,
    'end': _end,
    'location': _location,
    'points': _points,
    'checkins': _checkins,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final REQUIRERSVP = amplify_core.QueryField(fieldName: "requireRSVP");
  static final CANRSVP = amplify_core.QueryField(fieldName: "canRSVP");
  static final START = amplify_core.QueryField(fieldName: "start");
  static final END = amplify_core.QueryField(fieldName: "end");
  static final LOCATION = amplify_core.QueryField(fieldName: "location");
  static final POINTS = amplify_core.QueryField(fieldName: "points");
  static final CHECKINS = amplify_core.QueryField(
    fieldName: "checkins",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Checkin'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Event";
    modelSchemaDefinition.pluralName = "Events";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "Administrator" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.REQUIRERSVP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.CANRSVP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.START,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.END,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.LOCATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Event.POINTS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Event.CHECKINS,
      isRequired: false,
      ofModelName: 'Checkin',
      associatedKey: Checkin.EVENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _EventModelType extends amplify_core.ModelType<Event> {
  const _EventModelType();
  
  @override
  Event fromJson(Map<String, dynamic> jsonData) {
    return Event.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Event';
  }
}
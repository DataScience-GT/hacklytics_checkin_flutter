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


/** This is an auto generated class representing the AdminSettings type in your schema. */
class AdminSettings extends amplify_core.Model {
  static const classType = const _AdminSettingsModelType();
  final String id;
  final bool? _hacklyticsOpen;
  final List<String>? _participantEmails;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  bool? get hacklyticsOpen {
    return _hacklyticsOpen;
  }
  
  List<String>? get participantEmails {
    return _participantEmails;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const AdminSettings._internal({required this.id, hacklyticsOpen, participantEmails, createdAt, updatedAt}): _hacklyticsOpen = hacklyticsOpen, _participantEmails = participantEmails, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AdminSettings({String? id, bool? hacklyticsOpen, List<String>? participantEmails}) {
    return AdminSettings._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      hacklyticsOpen: hacklyticsOpen,
      participantEmails: participantEmails != null ? List<String>.unmodifiable(participantEmails) : participantEmails);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettings &&
      id == other.id &&
      _hacklyticsOpen == other._hacklyticsOpen &&
      DeepCollectionEquality().equals(_participantEmails, other._participantEmails);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AdminSettings {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("hacklyticsOpen=" + (_hacklyticsOpen != null ? _hacklyticsOpen!.toString() : "null") + ", ");
    buffer.write("participantEmails=" + (_participantEmails != null ? _participantEmails!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AdminSettings copyWith({String? id, bool? hacklyticsOpen, List<String>? participantEmails}) {
    return AdminSettings._internal(
      id: id ?? this.id,
      hacklyticsOpen: hacklyticsOpen ?? this.hacklyticsOpen,
      participantEmails: participantEmails ?? this.participantEmails);
  }
  
  AdminSettings copyWithModelFieldValues({
    ModelFieldValue<String>? id,
    ModelFieldValue<bool?>? hacklyticsOpen,
    ModelFieldValue<List<String>?>? participantEmails
  }) {
    return AdminSettings._internal(
      id: id == null ? this.id : id.value,
      hacklyticsOpen: hacklyticsOpen == null ? this.hacklyticsOpen : hacklyticsOpen.value,
      participantEmails: participantEmails == null ? this.participantEmails : participantEmails.value
    );
  }
  
  AdminSettings.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _hacklyticsOpen = json['hacklyticsOpen'],
      _participantEmails = json['participantEmails']?.cast<String>(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'hacklyticsOpen': _hacklyticsOpen, 'participantEmails': _participantEmails, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'hacklyticsOpen': _hacklyticsOpen,
    'participantEmails': _participantEmails,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final ID = amplify_core.QueryField(fieldName: "id");
  static final HACKLYTICSOPEN = amplify_core.QueryField(fieldName: "hacklyticsOpen");
  static final PARTICIPANTEMAILS = amplify_core.QueryField(fieldName: "participantEmails");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AdminSettings";
    modelSchemaDefinition.pluralName = "AdminSettings";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
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
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AdminSettings.HACKLYTICSOPEN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AdminSettings.PARTICIPANTEMAILS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
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

class _AdminSettingsModelType extends amplify_core.ModelType<AdminSettings> {
  const _AdminSettingsModelType();
  
  @override
  AdminSettings fromJson(Map<String, dynamic> jsonData) {
    return AdminSettings.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AdminSettings';
  }
}
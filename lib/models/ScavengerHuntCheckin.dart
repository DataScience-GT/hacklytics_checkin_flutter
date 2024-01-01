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


/** This is an auto generated class representing the ScavengerHuntCheckin type in your schema. */
class ScavengerHuntCheckin extends amplify_core.Model {
  static const classType = const _ScavengerHuntCheckinModelType();
  final String id;
  final String? _checkpointID;
  final String? _userID;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get checkpointID {
    try {
      return _checkpointID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get userID {
    try {
      return _userID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ScavengerHuntCheckin._internal({required this.id, required checkpointID, required userID, createdAt, updatedAt}): _checkpointID = checkpointID, _userID = userID, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ScavengerHuntCheckin({String? id, required String checkpointID, required String userID}) {
    return ScavengerHuntCheckin._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      checkpointID: checkpointID,
      userID: userID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScavengerHuntCheckin &&
      id == other.id &&
      _checkpointID == other._checkpointID &&
      _userID == other._userID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ScavengerHuntCheckin {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("checkpointID=" + "$_checkpointID" + ", ");
    buffer.write("userID=" + "$_userID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ScavengerHuntCheckin copyWith({String? id, String? checkpointID, String? userID}) {
    return ScavengerHuntCheckin._internal(
      id: id ?? this.id,
      checkpointID: checkpointID ?? this.checkpointID,
      userID: userID ?? this.userID);
  }
  
  ScavengerHuntCheckin copyWithModelFieldValues({
    ModelFieldValue<String>? id,
    ModelFieldValue<String>? checkpointID,
    ModelFieldValue<String>? userID
  }) {
    return ScavengerHuntCheckin._internal(
      id: id == null ? this.id : id.value,
      checkpointID: checkpointID == null ? this.checkpointID : checkpointID.value,
      userID: userID == null ? this.userID : userID.value
    );
  }
  
  ScavengerHuntCheckin.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _checkpointID = json['checkpointID'],
      _userID = json['userID'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'checkpointID': _checkpointID, 'userID': _userID, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'checkpointID': _checkpointID,
    'userID': _userID,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CHECKPOINTID = amplify_core.QueryField(fieldName: "checkpointID");
  static final USERID = amplify_core.QueryField(fieldName: "userID");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ScavengerHuntCheckin";
    modelSchemaDefinition.pluralName = "ScavengerHuntCheckins";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "Administrator", "Scavenger" ],
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
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ScavengerHuntCheckin.CHECKPOINTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ScavengerHuntCheckin.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _ScavengerHuntCheckinModelType extends amplify_core.ModelType<ScavengerHuntCheckin> {
  const _ScavengerHuntCheckinModelType();
  
  @override
  ScavengerHuntCheckin fromJson(Map<String, dynamic> jsonData) {
    return ScavengerHuntCheckin.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ScavengerHuntCheckin';
  }
}
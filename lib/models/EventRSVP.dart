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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the EventRSVP type in your schema. */
@immutable
class EventRSVP extends Model {
  static const classType = const _EventRSVPModelType();
  final String id;
  final String? _userID;
  final String? _userName;
  final String? _eventID;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get userID {
    try {
      return _userID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get userName {
    try {
      return _userName!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get eventID {
    try {
      return _eventID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const EventRSVP._internal({required this.id, required userID, required userName, required eventID, createdAt, updatedAt}): _userID = userID, _userName = userName, _eventID = eventID, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory EventRSVP({String? id, required String userID, required String userName, required String eventID}) {
    return EventRSVP._internal(
      id: id == null ? UUID.getUUID() : id,
      userID: userID,
      userName: userName,
      eventID: eventID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventRSVP &&
      id == other.id &&
      _userID == other._userID &&
      _userName == other._userName &&
      _eventID == other._eventID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("EventRSVP {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userID=" + "$_userID" + ", ");
    buffer.write("userName=" + "$_userName" + ", ");
    buffer.write("eventID=" + "$_eventID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  EventRSVP copyWith({String? id, String? userID, String? userName, String? eventID}) {
    return EventRSVP._internal(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      eventID: eventID ?? this.eventID);
  }
  
  EventRSVP.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userID = json['userID'],
      _userName = json['userName'],
      _eventID = json['eventID'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userID': _userID, 'userName': _userName, 'eventID': _eventID, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'userID': _userID, 'userName': _userName, 'eventID': _eventID, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USERID = QueryField(fieldName: "userID");
  static final QueryField USERNAME = QueryField(fieldName: "userName");
  static final QueryField EVENTID = QueryField(fieldName: "eventID");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "EventRSVP";
    modelSchemaDefinition.pluralName = "EventRSVPS";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "Administrator" ],
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.READ,
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE
        ]),
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.READ,
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EventRSVP.USERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EventRSVP.USERNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EventRSVP.EVENTID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _EventRSVPModelType extends ModelType<EventRSVP> {
  const _EventRSVPModelType();
  
  @override
  EventRSVP fromJson(Map<String, dynamic> jsonData) {
    return EventRSVP.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'EventRSVP';
  }
}
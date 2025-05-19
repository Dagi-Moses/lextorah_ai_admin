// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      tokenExpiresAt: DateTime.parse(json['tokenExpiresAt'] as String),
      trialEndsAt: DateTime.parse(json['trialEndsAt'] as String),
      token: json['token'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'tokenExpiresAt': instance.tokenExpiresAt.toIso8601String(),
      'trialEndsAt': instance.trialEndsAt.toIso8601String(),
      'token': instance.token,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.student: 'student',
  UserRole.trial: 'trial',
  UserRole.unknown: 'unknown',
};

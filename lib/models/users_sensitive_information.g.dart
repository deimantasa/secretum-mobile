// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_sensitive_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersSensitiveInformation _$UsersSensitiveInformationFromJson(Map json) =>
    UsersSensitiveInformation(
      json['secretKey'] as String? ?? '',
      json['primaryPassword'] as String? ?? '',
    );

Map<String, dynamic> _$UsersSensitiveInformationToJson(
        UsersSensitiveInformation instance) =>
    <String, dynamic>{
      'secretKey': instance.secretKey,
      'primaryPassword': instance.primaryPassword,
    };

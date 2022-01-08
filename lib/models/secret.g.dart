// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secret _$SecretFromJson(Map<String, dynamic> json) => Secret(
      json['addedBy'] as String,
      Utils.dateTimeFromISO(json['updatedAt'] as String),
      json['name'] as String,
      json['note'] as String,
      json['code'] as String,
    )..createdAt = Utils.dateTimeFromISO(json['createdAt'] as String);

Map<String, dynamic> _$SecretToJson(Secret instance) => <String, dynamic>{
      'createdAt': Utils.dateTimeToISO(instance.createdAt),
      'addedBy': instance.addedBy,
      'updatedAt': Utils.dateTimeToISO(instance.updatedAt),
      'name': instance.name,
      'note': instance.note,
      'code': instance.code,
    };

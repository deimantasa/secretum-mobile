// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) => User(
      UsersSensitiveInformation.fromJson(
          Map<String, dynamic>.from(json['sensitiveInformation'] as Map)),
    )..createdAt = Utils.dateTimeFromISO(json['createdAt'] as String);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'createdAt': Utils.dateTimeToISO(instance.createdAt),
      'sensitiveInformation': instance.sensitiveInformation.toJson(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    UsersSensitiveInformation.fromJson(
        Map<String, dynamic>.from(json['sensitiveInformation'] as Map)),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'sensitiveInformation': instance.sensitiveInformation.toJson(),
    };

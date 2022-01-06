// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) => User(
      UsersSensitiveInformation.fromJson(
          Map<String, dynamic>.from(json['sensitiveInformation'] as Map)),
      Utils.dateTimeFromInt(json['createdAt'] as int),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', Utils.dateTimeToInt(instance.createdAt));
  val['sensitiveInformation'] = instance.sensitiveInformation.toJson();
  return val;
}

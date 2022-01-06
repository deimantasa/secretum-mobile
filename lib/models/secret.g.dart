// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secret _$SecretFromJson(Map<String, dynamic> json) => Secret(
      json['addedBy'] as String,
      Utils.dateTimeFromInt(json['createdAt'] as int),
      json['name'] as String,
      json['note'] as String,
      json['code'] as String,
    );

Map<String, dynamic> _$SecretToJson(Secret instance) {
  final val = <String, dynamic>{
    'addedBy': instance.addedBy,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', Utils.dateTimeToInt(instance.createdAt));
  val['name'] = instance.name;
  val['note'] = instance.note;
  val['code'] = instance.code;
  return val;
}

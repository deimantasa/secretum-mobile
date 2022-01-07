// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secret _$SecretFromJson(Map<String, dynamic> json) => Secret(
      json['addedBy'] as String,
      Utils.dateTimeFromISO(json['createdAt'] as String),
      Utils.dateTimeFromISO(json['updatedAt'] as String),
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

  writeNotNull('createdAt', Utils.dateTimeToISO(instance.createdAt));
  writeNotNull('updatedAt', Utils.dateTimeToISO(instance.updatedAt));
  val['name'] = instance.name;
  val['note'] = instance.note;
  val['code'] = instance.code;
  return val;
}

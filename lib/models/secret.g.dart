// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secret _$SecretFromJson(Map json) {
  return Secret(
    json['addedBy'] as String?,
    json['name'] as String? ?? '',
    json['note'] as String? ?? '',
    json['code'] as String? ?? '',
  );
}

Map<String, dynamic> _$SecretToJson(Secret instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('addedBy', instance.addedBy);
  writeNotNull('name', instance.name);
  writeNotNull('note', instance.note);
  writeNotNull('code', instance.code);
  return val;
}

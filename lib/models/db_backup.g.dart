// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DbBackup _$DbBackupFromJson(Map<String, dynamic> json) {
  return DbBackup(
    (json['secrets'] as List<dynamic>?)
            ?.map((e) => Secret.fromJson(e as Map<String, dynamic>, isEncrypted: false))
            .toList() ??
        [],
    DateTime.parse(json['backupDate'] as String),
  );
}

Map<String, dynamic> _$DbBackupToJson(DbBackup instance) => <String, dynamic>{
      'secrets': instance.secrets.map((e) => e.toJson(isEncrypted: false)).toList(),
      'backupDate': instance.backupDate.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clickable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clickable _$ClickableFromJson(Map<String, dynamic> json) {
  return Clickable(
    json['clickThreshold'] as int,
    json['currentClickCount'] as int,
  );
}

Map<String, dynamic> _$ClickableToJson(Clickable instance) => <String, dynamic>{
      'clickThreshold': instance.clickThreshold,
      'currentClickCount': instance.currentClickCount,
    };

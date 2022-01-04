import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/utils/extensions.dart';

/// [SensitiveInformation] is an abstract super class which should be extended if an object should be sensitive.
/// Sensitive in this context mean that it's values, after being sent to firestore, will be hashed.
@JsonSerializable(anyMap: true, explicitToJson: true, createFactory: false, createToJson: false)
abstract class SensitiveInformation {
  SensitiveInformation();

  /// Generic method which should be used with all child classes, when generating [toJson] object.
  /// [sensitiveDataMap] - [Map] which will be returned.
  /// [isHashed] - if true, it will return hashed [Map], otherwise it will return [Map] as it is.
  Map<String, dynamic> getJson(Map<String, dynamic> sensitiveDataMap, {bool isHashed = true}) {
    Map<String, dynamic> dataMap = sensitiveDataMap;

    if (isHashed) {
      dataMap.hashData();
    }

    return dataMap;
  }
}

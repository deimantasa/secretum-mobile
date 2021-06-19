import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/models/secret.dart';
part 'db_backup.g.dart';

@JsonSerializable(explicitToJson: true)
class DbBackup {
  /// **********IMPORTANT**********
  /// When parsing from/to, [db_backup.g.dart] is manually modified to exclude encryption.
  /// Make sure it's always there.
  /// **********IMPORTANT**********
  @JsonKey(defaultValue: [])
  final List<Secret> secrets;
  final DateTime backupDate;

  DbBackup(this.secrets, this.backupDate);

  factory DbBackup.fromJson(Map<String, dynamic> json) {
    return _$DbBackupFromJson(json);
  }
  Map<String, dynamic> toJson() {
    // Nullify `createdAt` because we are parsing it to TimeStamp due to Firestore. However, when storing
    // locally, it won't accept `TimeStamp` and parsing crash.
    this.secrets.forEach((element) {
      element.createdAt = null;
    });
    final Map<String, dynamic> dbBackupMap = _$DbBackupToJson(this);

    return dbBackupMap;
  }
}

import 'package:secretum/models/secret.dart';

class BackupPreviewModel {
  final String pathToBackup;
  final List<Secret> secrets = [];

  BackupPreviewModel(this.pathToBackup);
}

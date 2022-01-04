import 'dart:io';

import 'backup_preview_contract.dart';
import 'backup_preview_model.dart';

class BackupPreviewPresenter {
  final BackupPreviewView _view;
  final BackupPreviewModel _model;

  BackupPreviewPresenter(this._view, this._model);

  Future<void> init() async {
    final File file = File(_model.pathToBackup);

    _model.contentOfBackup = await file.readAsString();
    _view.updateView();
  }
}

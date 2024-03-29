import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:secretum/models/secret.dart';

import 'backup_preview_contract.dart';
import 'backup_preview_model.dart';

class BackupPreviewPresenter {
  final BackupPreviewView _view;
  final BackupPreviewModel _model;

  BackupPreviewPresenter(this._view, this._model);

  Future<void> init() async {
    final File file = File(_model.pathToBackup);

    final String contentOfBackup = await file.readAsString();
    final List<dynamic> secretStrings = json.decode(contentOfBackup);
    final List<Secret> secrets = secretStrings.map((e) => Secret.fromJson(e)).toList();

    _model.secrets.addAll(secrets);
    _view.updateView();
  }

  Future<void> copyCode(String code) async {
    if (code.isEmpty) {
      _view.showMessage('Nothing to copy, code is empty', isSuccess: false);
      return;
    }

    await Clipboard.setData(ClipboardData(text: code));

    _view.showMessage('Code was copied to clipboard. Do not forget to clear your clipboard once you will use the code');
  }

  Future<void> clearClipboard() async {
    await Clipboard.setData(ClipboardData(text: ''));

    _view.showMessage('Clipboard was cleared');
  }
}

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/services/storage_service.dart';

import 'secret_key_preview_contract.dart';
import 'secret_key_preview_model.dart';

class SecretKeyPreviewPresenter {
  final SecretKeyView _view;
  final SecretKeyPreviewModel _model;
  final StorageService _storageService;

  SecretKeyPreviewPresenter(this._view, this._model) : _storageService = GetIt.instance<StorageService>();

  Future<void> init() async {
    _model.secretKey = await _storageService.getSecretKey();
    _view.updateView();
  }

  Future<void> copySecretKey() async {
    await Clipboard.setData(ClipboardData(text: _model.secretKey));

    _model.isKeyCopied = true;
    _view.showMessage('Secret Key was copied to clipboard');
    _view.updateView();
  }
}

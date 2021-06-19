import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/services/storage_service.dart';

import 'secret_key_preview_contract.dart';
import 'secret_key_preview_model.dart';

class SecretKeyPreviewPresenter implements Presenter {
  final View _view;
  final SecretKeyPreviewModel _secretKeyPreviewModel;
  final StorageService _storageService;

  SecretKeyPreviewPresenter(
    this._view,
    this._secretKeyPreviewModel, {
    StorageService? storageService,
  }) : _storageService = storageService ?? GetIt.instance<StorageService>();

  Future<void> init() async {
    _secretKeyPreviewModel.secretKey = await _storageService.getSecretKey();
    _view.updateView();
  }

  Future<void> copySecretKey() async {
    await Clipboard.setData(ClipboardData(text: _secretKeyPreviewModel.secretKey));

    _secretKeyPreviewModel.isKeyCopied = true;
    _view.showMessage('Secret Key was copied to clipboard');
    _view.updateView();
  }
}

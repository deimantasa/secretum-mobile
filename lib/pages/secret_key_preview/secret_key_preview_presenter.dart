import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/services/storage_service.dart';

import 'secret_key_preview_contract.dart';
import 'secret_key_preview_model.dart';

class SecretKeyPreviewPresenter implements Presenter {
  late final View _view;
  late final SecretKeyPreviewModel _secretKeyPreviewModel;

  late final StorageService _storageService;

  SecretKeyPreviewPresenter(View view, BuildContext context, SecretKeyPreviewModel secretKeyPreviewModel) {
    _view = view;
    _secretKeyPreviewModel = secretKeyPreviewModel;

    _storageService = GetIt.instance<StorageService>();
  }

  Future<void> init() async {
    _secretKeyPreviewModel.secretKey = await _storageService.getSecretKey();
    _view.updateView();
  }

  Future<void> copySecretKey() async {
    await Clipboard.setData(ClipboardData(text: _secretKeyPreviewModel.secretKey));

    _secretKeyPreviewModel.isKeyCopied = true;
    _view.showMessage("Secret Key copied to clipboard");
    _view.updateView();
  }
}

import 'package:flutter/material.dart';
import 'package:secretum/utils/dialogs.dart';

import 'secret_key_preview_contract.dart';
import 'secret_key_preview_model.dart';
import 'secret_key_preview_presenter.dart';

class SecretKeyPreviewPage extends StatefulWidget {
  @override
  _SecretKeyPreviewPageState createState() => _SecretKeyPreviewPageState();
}

class _SecretKeyPreviewPageState extends State<SecretKeyPreviewPage> implements View {
  late final SecretKeyPreviewModel _secretKeyPreviewModel;
  late final SecretKeyPreviewPresenter _secretKeyPreviewPresenter;

  @override
  void initState() {
    _secretKeyPreviewModel = SecretKeyPreviewModel();
    _secretKeyPreviewPresenter = SecretKeyPreviewPresenter(this, context, _secretKeyPreviewModel);
    _secretKeyPreviewPresenter.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Spacer(),
            Text(
              "VERY IMPORTANT",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Text(
              "Save below code. With only this code you will be able to recover your account if you delete the app or sign-out.",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              "${_secretKeyPreviewModel.secretKey}",
              style: Theme.of(context).textTheme.headline6!.copyWith(decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text("Copy"),
                    onPressed: () => _secretKeyPreviewPresenter.copySecretKey(),
                  ),
                ),
                if (_secretKeyPreviewModel.isKeyCopied) ...[
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text("Finish"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void showMessage(String message, {bool isSuccess = true}) {
    Dialogs.showMessage(message: message, isSuccess: isSuccess);
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:secretum/utils/dialogs.dart';

import 'secret_key_preview_contract.dart';
import 'secret_key_preview_model.dart';
import 'secret_key_preview_presenter.dart';

class SecretKeyPreviewPage extends StatefulWidget {
  @override
  _SecretKeyPreviewPageState createState() => _SecretKeyPreviewPageState();
}

class _SecretKeyPreviewPageState extends State<SecretKeyPreviewPage> implements SecretKeyView {
  late final SecretKeyPreviewModel _model;
  late final SecretKeyPreviewPresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = SecretKeyPreviewModel();
    _presenter = SecretKeyPreviewPresenter(this, _model);
    _presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Spacer(),
          Text(
            'VERY IMPORTANT',
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Text(
            'Save below code. With only this code you will be able to recover your account if you delete the app or sign-out.',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Text(
            '${_model.secretKey}',
            style: Theme.of(context).textTheme.headline6!.copyWith(decoration: TextDecoration.underline),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text('Copy'),
                  onPressed: () => _presenter.copySecretKey(),
                ),
              ),
              if (_model.isKeyCopied) ...[
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    child: Text('Finish'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }
}

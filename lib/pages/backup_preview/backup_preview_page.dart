import 'package:flutter/material.dart';
import 'package:secretum/utils/dialogs.dart';

import 'backup_preview_contract.dart';
import 'backup_preview_model.dart';
import 'backup_preview_presenter.dart';

class BackupPreviewPage extends StatefulWidget {
  final String pathToFile;

  const BackupPreviewPage({Key? key, required this.pathToFile}) : super(key: key);

  @override
  _BackupPreviewPageState createState() => _BackupPreviewPageState();
}

class _BackupPreviewPageState extends State<BackupPreviewPage> implements BackupPreviewView {
  late final BackupPreviewModel _model;
  late final BackupPreviewPresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = BackupPreviewModel(widget.pathToFile);
    _presenter = BackupPreviewPresenter(this, _model);
    _presenter.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String fileName = _model.pathToBackup.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backup Preview'),
            Text(
              fileName,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
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
    return SelectableText('${_model.contentOfBackup}');
  }
}

import 'package:flutter/material.dart';
import 'package:secretum/utils/dialogs.dart';

import 'secret_details_contract.dart';
import 'secret_details_model.dart';
import 'secret_details_presenter.dart';

class SecretDetailsPage extends StatefulWidget {
  final String secretId;

  const SecretDetailsPage({
    Key? key,
    required this.secretId,
  }) : super(key: key);
  @override
  _SecretDetailsPageState createState() => _SecretDetailsPageState();
}

class _SecretDetailsPageState extends State<SecretDetailsPage> implements SecretDetailsView {
  late final SecretDetailsModel _model;
  late final SecretDetailsPresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = SecretDetailsModel(widget.secretId);
    _presenter = SecretDetailsPresenter(this, _model);
    _presenter.init();
  }

  @override
  void dispose() {
    _presenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          '${_model.secret?.name}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Rename Secret'),
                        onTap: () async {
                          Navigator.pop(context);

                          final String? secretsName = await Dialogs.showEditEntryBottomSheet(
                            context,
                            title: "New Secret's Name",
                            hintText: 'Enter new name',
                            entry: _model.secret!.name,
                            buttonText: 'Update',
                            textCapitalization: TextCapitalization.words,
                            validator: (text) => text != null && text.isNotEmpty ? null : 'Secret cannot be empty',
                            validateWithPrimaryPassword: false,
                            validateWithBiometric: false,
                          );

                          if (secretsName != null) {
                            _presenter.updateSecretName(secretsName);
                          }
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete Secret'),
                        onTap: () {
                          // Close bottom sheet
                          Navigator.pop(context);

                          _showDeleteSecretDialog();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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

  @override
  void closePage() {
    Navigator.pop(context);
  }

  Widget _buildBody() {
    final String? note = _model.secret?.note;
    final String? code = _model.secret?.code;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Notes'),
          subtitle: note == null || note.isEmpty ? null : Text(note),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final String? newNote = await Dialogs.showEditEntryBottomSheet(
                context,
                title: 'Update Note',
                entry: _model.secret?.note,
                hintText: 'Enter some notes/hints about the secret',
                buttonText: 'Update',
                textCapitalization: TextCapitalization.sentences,
                validator: (text) => null,
                validateWithPrimaryPassword: false,
                validateWithBiometric: false,
              );

              if (newNote != null) {
                _presenter.updateSecretNote(newNote);
              }
            },
          ),
          onTap: _model.secret?.note.isNotEmpty == true
              ? () async {
                  Dialogs.showInformationBottomSheet(
                    context,
                    title: 'Note',
                    content: _model.secret!.note,
                    buttonText: 'Close',
                    onPressed: () => Navigator.pop(context),
                  );
                }
              : () => showMessage('There is no note saved'),
        ),
        Divider(height: 1),
        ListTile(
            title: Text('Code'),
            subtitle: code == null || code.isEmpty ? null : Text('********'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final String? newCode = await Dialogs.showEditEntryBottomSheet(
                  context,
                  title: 'Update Code',
                  hintText: 'Enter new code',
                  entry: _model.secret?.code,
                  buttonText: 'Update',
                  textCapitalization: TextCapitalization.none,
                  validator: (text) => null,
                  validateWithPrimaryPassword: true,
                  validateWithBiometric: false,
                );

                if (newCode != null) {
                  _presenter.updateSecretCode(newCode);
                }
              },
            ),
            onTap: _model.secret?.code.isNotEmpty == true
                ? () async {
                    Dialogs.showInformationBottomSheet(
                      context,
                      title: 'Code',
                      content: _model.secret!.code,
                      buttonText: 'Copy',
                      onPressed: () => _presenter.copyText(_model.secret!.code),
                    );
                  }
                : () => showMessage('There is no code saved')),
        Divider(height: 1),
      ],
    );
  }

  void _showDeleteSecretDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure want to delete everything?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                // Close previous dialog
                Navigator.pop(context);

                final String? password = await Dialogs.showPasswordConfirmationDialog(
                  context,
                  hintText: 'Primary Password',
                );

                if (password != null) {
                  _presenter.deleteSecret(password);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

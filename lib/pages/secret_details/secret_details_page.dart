import 'package:flutter/material.dart';
import 'package:secretum/models/secret.dart';
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

class _SecretDetailsPageState extends State<SecretDetailsPage> implements View {
  late final SecretDetailsModel _secretDetailsModel;
  late final SecretDetailsPresenter _secretDetailsPresenter;

  @override
  void initState() {
    super.initState();

    _secretDetailsModel = SecretDetailsModel(widget.secretId);
    _secretDetailsPresenter = SecretDetailsPresenter(this, _secretDetailsModel);
    _secretDetailsPresenter.init();
  }

  @override
  void dispose() {
    _secretDetailsPresenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          '${_secretDetailsModel.secret?.name}',
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

                          String? secretsName = await Dialogs.showEditEntryBottomSheet(
                            context,
                            title: "New Secret's Name",
                            hintText: 'Enter new name',
                            entry: _secretDetailsModel.secret!.name,
                            buttonText: 'Update',
                            textCapitalization: TextCapitalization.words,
                            validateWithPrimaryPassword: false,
                            validateWithSecondaryPassword: false,
                            validateWithBiometric: false,
                          );

                          if (secretsName != null) {
                            _secretDetailsPresenter.updateSecret(Secret.update(name: secretsName));
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
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    onPressed: () async {
                                      //Close previous dialog
                                      Navigator.pop(context);

                                      final String? password = await Dialogs.showPasswordConfirmationDialog(
                                        context,
                                        hintText: 'Primary Password',
                                      );

                                      if (password != null) {
                                        _secretDetailsPresenter.deleteSecret(password);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
    final String? note = _secretDetailsModel.secret?.note;
    final String? code = _secretDetailsModel.secret?.code;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            title: Text('Notes'),
            subtitle: note == null || note.isEmpty ? null : Text('********'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                String? newNote = await Dialogs.showEditEntryBottomSheet(
                  context,
                  title: 'Update Note',
                  entry: _secretDetailsModel.secret?.note,
                  hintText: 'Enter some notes/hints about the secret',
                  buttonText: 'Update',
                  textCapitalization: TextCapitalization.sentences,
                  validateWithPrimaryPassword: true,
                  validateWithSecondaryPassword: false,
                  validateWithBiometric: true,
                );

                if (newNote != null) {
                  _secretDetailsPresenter.updateSecret(Secret.update(note: newNote));
                }
              },
            ),
            onTap: _secretDetailsModel.secret?.note?.isNotEmpty == true
                ? () async {
                    final bool isSuccess = await _secretDetailsPresenter.authenticate();

                    if (isSuccess) {
                      Dialogs.showInformationBottomSheet(
                        context,
                        title: 'Note',
                        content: _secretDetailsModel.secret!.note!,
                        buttonText: 'Close',
                        onPressed: () => Navigator.pop(context),
                      );
                    }
                  }
                : () => showMessage('There is no note saved')),
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
                  entry: _secretDetailsModel.secret?.code,
                  buttonText: 'Update',
                  textCapitalization: TextCapitalization.none,
                  validateWithPrimaryPassword: true,
                  validateWithSecondaryPassword: false,
                  validateWithBiometric: true,
                );

                if (newCode != null) {
                  _secretDetailsPresenter.updateSecret(Secret.update(code: newCode));
                }
              },
            ),
            onTap: _secretDetailsModel.secret?.code?.isNotEmpty == true
                ? () async {
                    final bool isSuccess = await _secretDetailsPresenter.authenticate();

                    if (isSuccess) {
                      Dialogs.showInformationBottomSheet(
                        context,
                        title: 'Code',
                        content: _secretDetailsModel.secret!.code!,
                        buttonText: 'Copy',
                        onPressed: () => _secretDetailsPresenter.copyText(_secretDetailsModel.secret!.code!),
                      );
                    }
                  }
                : () => showMessage('There is no code saved')),
        Divider(height: 1),
      ],
    );
  }
}

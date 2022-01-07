import 'package:flutter/material.dart';
import 'package:secretum/utils/dialogs.dart';

import 'edit_entry_contract.dart';
import 'edit_entry_model.dart';
import 'edit_entry_presenter.dart';

class EditEntryPage extends StatefulWidget {
  final String title;
  final String description;
  final String hintText;
  final String entry;
  final String buttonText;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool validateWithPrimaryPassword;
  final bool validateWithBiometric;

  const EditEntryPage({
    Key? key,
    required this.title,
    this.description = '',
    required this.hintText,
    required this.entry,
    required this.buttonText,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    required this.validateWithPrimaryPassword,
    required this.validateWithBiometric,
  }) : super(key: key);
  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> implements EditEntryView {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _textEditingController;
  late final EditEntryModel _model;
  late final EditEntryPresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = EditEntryModel(
      widget.title,
      widget.description,
      widget.hintText,
      widget.entry,
      widget.buttonText,
      widget.textCapitalization,
      widget.validateWithPrimaryPassword,
      widget.validateWithBiometric,
    );
    _presenter = EditEntryPresenter(this, _model);

    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: _model.entry,
        selection: TextSelection.fromPosition(
          TextPosition(offset: _model.entry.length),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        top: 0,
        right: 8,
        // Use bottom padding to detect if keyboard is shown, so it'd not hide our rendered elements
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _model.title,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(height: 1),
          SizedBox(height: 16),
          if (_model.description.isNotEmpty) ...[
            Text(_model.description),
            SizedBox(height: 16),
          ],
          Flexible(
            child: Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                controller: _textEditingController,
                decoration: InputDecoration.collapsed(hintText: _model.hintText),
                textCapitalization: widget.textCapitalization,
                validator: widget.validator,
                minLines: null,
                maxLines: null,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text(_model.buttonText),
                    onPressed: () async {
                      // Make sure that validation passes before we execute further logic
                      if (_formKey.currentState?.validate() != true) {
                        return;
                      }

                      if (_model.validateWithPrimaryPassword) {
                        final String? password = await Dialogs.showPasswordConfirmationDialog(
                          context,
                          hintText: 'Primary Password',
                        );

                        final bool isPasswordValid = _presenter.validatePrimaryPassword(password);
                        if (!isPasswordValid) {
                          showMessage('Password is invalid', isSuccess: false);
                          return;
                        }
                      }

                      if (_model.validateWithBiometric) {
                        final bool isSuccess = await _presenter.authenticate();

                        if (!isSuccess) {
                          showMessage('Authentication failed', isSuccess: false);
                          return;
                        }
                      }

                      Navigator.pop(context, _textEditingController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
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

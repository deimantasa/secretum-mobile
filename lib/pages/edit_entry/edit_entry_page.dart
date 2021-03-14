import 'package:flutter/material.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:secretum/utils/utils.dart';

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
  final bool validateWithPrimaryPassword;
  final bool validateWithSecondaryPassword;
  final bool validateWithBiometric;

  const EditEntryPage({
    Key? key,
    required this.title,
    this.description = "",
    required this.hintText,
    required this.entry,
    required this.buttonText,
    this.textCapitalization = TextCapitalization.none,
    required this.validateWithPrimaryPassword,
    required this.validateWithSecondaryPassword,
    required this.validateWithBiometric,
  }) : super(key: key);
  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> implements View {
  late TextEditingController _textEditingController;

  late final EditEntryModel _editEntryModel;
  late final EditEntryPresenter _editEntryPresenter;

  @override
  void initState() {
    _editEntryModel = EditEntryModel(
      widget.title,
      widget.description,
      widget.hintText,
      widget.entry,
      widget.buttonText,
      widget.textCapitalization,
      widget.validateWithPrimaryPassword,
      widget.validateWithSecondaryPassword,
      widget.validateWithBiometric,
    );
    _editEntryPresenter = EditEntryPresenter(this, context, _editEntryModel);

    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: _editEntryModel.entry,
        selection: TextSelection.fromPosition(
          TextPosition(offset: _editEntryModel.entry.length),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        top: 0,
        right: 8,
        //Use bottom padding to detect if keyboard is shown, so it'd not hide our rendered elements
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
                _editEntryModel.title,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(height: 1),
          SizedBox(height: 8),
          if (_editEntryModel.description.isNotEmpty) ...[
            Text(_editEntryModel.description),
            SizedBox(height: 16),
          ],
          Flexible(
            child: TextFormField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration.collapsed(hintText: _editEntryModel.hintText),
              textCapitalization: widget.textCapitalization,
              minLines: null,
              maxLines: null,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text(_editEntryModel.buttonText),
                    onPressed: () async {
                      if (_editEntryModel.validateWithPrimaryPassword) {
                        String? password = await Dialogs.showPasswordConfirmationDialog(
                          context,
                          hintText: "Primary Password",
                        );
                        bool isPasswordValid = _editEntryPresenter.validatePrimaryPassword(password);
                        if (!isPasswordValid) {
                          showMessage("Password is invalid", isSuccess: false);
                          return;
                        }
                      }

                      if (_editEntryModel.validateWithSecondaryPassword) {
                        String? password = await Dialogs.showPasswordConfirmationDialog(
                          context,
                          hintText: "Secondary Password",
                        );
                        bool isPasswordValid = _editEntryPresenter.validateSecondaryPassword(password);
                        if (!isPasswordValid) {
                          showMessage("Password is invalid", isSuccess: false);
                          return;
                        }
                      }

                      if (_editEntryModel.validateWithBiometric) {
                        bool isSuccess = await Utils.authViaBiometric();
                        if (!isSuccess) {
                          showMessage("Authentication failed", isSuccess: false);
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
    Dialogs.showMessage(context, message: message, isSuccess: isSuccess);
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }
}

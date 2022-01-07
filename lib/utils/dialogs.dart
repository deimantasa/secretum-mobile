import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secretum/pages/edit_entry/edit_entry_page.dart';
import 'package:secretum/pages/secret_key_preview/secret_key_preview_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Dialogs {
  static Future<void> showMessage({
    required String message,
    bool isSuccess = true,
  }) async {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      gravity: ToastGravity.TOP,
    );
  }

  static Future<String?> showPasswordConfirmationDialog(
    BuildContext context, {
    required String hintText,
  }) async {
    String? password = await showDialog(
      context: context,
      builder: (context) {
        String? password;
        return AlertDialog(
          title: Text('Verify'),
          content: TextFormField(
            autofocus: true,
            onChanged: (input) => password = input,
            obscureText: true,
            decoration: InputDecoration(hintText: hintText),
            onEditingComplete: () => Navigator.pop(context, password),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () => Navigator.pop(context, password),
            ),
          ],
        );
      },
    );

    return password;
  }

  static Future<void> showSecretKeyBottomSheet(BuildContext context) async {
    showBarModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SecretKeyPreviewPage(),
        );
      },
    );
  }

  static Future<String?> showEditEntryBottomSheet(
    BuildContext context, {
    required String title,
    String? description,
    required String hintText,
    required String? entry,
    required String buttonText,
    required TextCapitalization textCapitalization,
    required String? Function(String?) validator,
    required bool validateWithPrimaryPassword,
    required bool validateWithBiometric,
  }) async {
    final String? newEntry = await showBarModalBottomSheet<String?>(
      context: context,
      builder: (context) {
        return EditEntryPage(
          title: title,
          description: description ?? '',
          hintText: hintText,
          entry: entry ?? '',
          buttonText: buttonText,
          textCapitalization: textCapitalization,
          validator: validator,
          validateWithPrimaryPassword: validateWithPrimaryPassword,
          validateWithBiometric: validateWithBiometric,
        );
      },
    );
    return newEntry;
  }

  static void showInformationBottomSheet(
    BuildContext context, {
    required String title,
    required String content,
    required String buttonText,
    required void Function() onPressed,
  }) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
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
                    title,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(height: 1),
              SizedBox(height: 8),
              Text(content),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(buttonText),
                        onPressed: onPressed,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

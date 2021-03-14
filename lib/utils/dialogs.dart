import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secretum/pages/edit_entry/edit_entry_page.dart';
import 'package:secretum/pages/secret_key_preview/secret_key_preview_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Dialogs {
  static Future<void> showMessage(
    BuildContext context, {
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
          title: Text("Verify"),
          content: TextFormField(
            autofocus: true,
            onChanged: (input) => password = input,
            obscureText: true,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Confirm"),
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
    required bool validateWithPrimaryPassword,
    required bool validateWithSecondaryPassword,
    required bool validateWithBiometric,
  }) async {
    String? newEntry = await showBarModalBottomSheet<String?>(
      context: context,
      builder: (context) {
        return EditEntryPage(
          title: title,
          description: description ?? "",
          hintText: hintText,
          entry: entry ?? "",
          buttonText: buttonText,
          textCapitalization: textCapitalization,
          validateWithPrimaryPassword: validateWithPrimaryPassword,
          validateWithSecondaryPassword: validateWithSecondaryPassword,
          validateWithBiometric: validateWithBiometric,
        );
      },
    );
    return newEntry;
  }
}

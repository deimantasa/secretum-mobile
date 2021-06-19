import 'package:flutter/cupertino.dart';

class EditEntryModel {
  final String title;
  final String description;
  final String hintText;
  final String entry;
  final String buttonText;
  final TextCapitalization textCapitalization;
  final bool validateWithPrimaryPassword;
  final bool validateWithSecondaryPassword;
  final bool validateWithBiometric;

  EditEntryModel(
    this.title,
    this.description,
    this.hintText,
    this.entry,
    this.buttonText,
    this.textCapitalization,
    this.validateWithPrimaryPassword,
    this.validateWithSecondaryPassword,
    this.validateWithBiometric,
  );
}

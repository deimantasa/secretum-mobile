import 'package:flutter/cupertino.dart';

class EditEntryModel {
  late final String title;
  late final String description;
  late final String hintText;
  late final String entry;
  late final String buttonText;
  late final TextCapitalization textCapitalization;
  late final bool validateWithPrimaryPassword;
  late final bool validateWithSecondaryPassword;
  late final bool validateWithBiometric;

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

import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/models/sensitive_information.dart';

part 'users_sensitive_information.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class UsersSensitiveInformation extends SensitiveInformation {
  static const kFieldSecretKey = 'secretKey';

  /// User's Hashed Secret Key which is used for Encryption/Decryption
  @JsonKey(defaultValue: '')
  final String secretKey;

  /// [primaryPassword] is the main password. It's used to protect critical functionality.
  @JsonKey(defaultValue: '')
  final String primaryPassword;

  UsersSensitiveInformation(this.secretKey, this.primaryPassword);

  UsersSensitiveInformation.newUser(this.secretKey, this.primaryPassword);

  factory UsersSensitiveInformation.fromJson(Map<String, dynamic> json) => _$UsersSensitiveInformationFromJson(json);

  Map<String, dynamic> toJson({bool isHashed = true}) {
    final Map<String, dynamic> dataMap = _$UsersSensitiveInformationToJson(this);

    return getJson(dataMap, isHashed: isHashed);
  }
}

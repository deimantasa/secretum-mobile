import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/models/firestore_metadata.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/utils/extensions.dart';

part 'user.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class User extends FirestoreMetadata {
  static const String kMapSensitiveInformation = "sensitiveInformation";
  late UsersSensitiveInformation sensitiveInformation;

  User(this.sensitiveInformation);

  User.newUser(this.sensitiveInformation);

  factory User.fromFirestore(DocumentSnapshot documentSnapshot, Map<String, dynamic> data) {
    data.decrypt();

    User user = _$UserFromJson(data);
    user.documentSnapshot = documentSnapshot;

    return user;
  }

  factory User.fromFirestoreChanged(DocumentChange documentChange, Map<String, dynamic> data) {
    data.decrypt();

    User user = _$UserFromJson(data);
    user.documentSnapshot = documentChange.doc;
    user.documentChangeType = documentChange.type;
    return user;
  }

  factory User.fromJson(Map<String, dynamic> json, {bool isEncrypted = true}) {
    if (isEncrypted) {
      json.decrypt();
    }

    User user = _$UserFromJson(json);
    return user;
  }

  Map<String, dynamic> toJson({bool isEncrypted = true}) {
    Map<String, dynamic> dataMap = _$UserToJson(this);

    if (isEncrypted) {
      dataMap.encrypt();
    }

    return dataMap;
  }
}

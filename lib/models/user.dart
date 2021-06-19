import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/models/firestore_metadata.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/utils/extensions.dart';

part 'user.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class User extends FirestoreMetadata {
  static const String kMapSensitiveInformation = 'sensitiveInformation';

  String get id => this.documentSnapshot.id;

  late UsersSensitiveInformation sensitiveInformation;

  User(this.sensitiveInformation);

  User.newUser(this.sensitiveInformation);

  factory User.fromFirestore(DocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    data.decrypt();

    final User user = _$UserFromJson(data);
    user.documentSnapshot = documentSnapshot;

    return user;
  }

  factory User.fromFirestoreChanged(DocumentChange documentChange) {
    final Map<String, dynamic> data = documentChange.doc.data() as Map<String, dynamic>;
    data.decrypt();

    final User user = _$UserFromJson(data);
    user.documentSnapshot = documentChange.doc;
    user.documentChangeType = documentChange.type;

    return user;
  }

  factory User.fromJson(
    Map<String, dynamic> json,
    EncryptionService encryptionService, {
    bool isEncrypted = true,
  }) {
    if (isEncrypted) {
      json.decrypt();
    }

    final User user = _$UserFromJson(json);
    return user;
  }

  Map<String, dynamic> toJson({bool isEncrypted = true}) {
    final Map<String, dynamic> dataMap = _$UserToJson(this);

    if (isEncrypted) {
      dataMap.encrypt();
    }

    return dataMap;
  }
}

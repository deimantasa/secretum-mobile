import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/models/firestore_metadata.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/utils/extensions.dart';
import 'package:secretum/utils/utils.dart';

part 'user.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class User extends FirestoreMetadata {
  String get id => this.documentSnapshot.id;

  static const String kMapSensitiveInformation = 'sensitiveInformation';
  late final UsersSensitiveInformation sensitiveInformation;

  User(this.sensitiveInformation) : super(createdAt: clock.now());

  User.newUser(this.sensitiveInformation) : super(createdAt: clock.now());

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

  // FIXME(aurimas): there is a slight glitch - we cannot not decrypt our data, because then
  // [createdAt] is returned as a not ISO compatible string which will fail parsing.
  // Many different ways of how to handle it - leave it for now.
  factory User.fromJson(Map<String, dynamic> json, {bool isEncrypted = true}) {
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

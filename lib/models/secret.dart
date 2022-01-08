import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/models/firestore_metadata.dart';
import 'package:secretum/utils/extensions.dart';
import 'package:secretum/utils/utils.dart';

part 'secret.g.dart';

@JsonSerializable(anyMap: false, explicitToJson: true)
class Secret extends FirestoreMetadata {
  String get id => this.documentSnapshot.id;

  static const String kFieldAddedBy = 'addedBy';
  final String addedBy;
  static const String kFieldCreatedAt = 'createdAt';
  @JsonKey(fromJson: Utils.dateTimeFromISO, toJson: Utils.dateTimeToISO)
  DateTime updatedAt;
  String name;
  String note;
  String code;

  Secret(this.addedBy, this.updatedAt, this.name, this.note, this.code) : super(createdAt: updatedAt);

  Secret.newSecret(
    DateTime dateTime, {
    required this.addedBy,
    required this.name,
  })  : this.updatedAt = dateTime,
        this.note = '',
        this.code = '',
        super(createdAt: dateTime);

  factory Secret.fromFirestore(DocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    data.decrypt();

    final Secret secret = _$SecretFromJson(data);

    secret.documentSnapshot = documentSnapshot;
    return secret;
  }

  factory Secret.fromFirestoreChanged(DocumentChange documentChange) {
    final Map<String, dynamic> data = documentChange.doc.data() as Map<String, dynamic>;
    data.decrypt();

    final Secret secret = _$SecretFromJson(data);

    secret.documentSnapshot = documentChange.doc;
    secret.documentChangeType = documentChange.type;
    return secret;
  }

  factory Secret.fromJson(Map<String, dynamic> json, {bool isEncrypted = true}) {
    if (isEncrypted) {
      json.decrypt();
    }

    final Secret secret = _$SecretFromJson(json);

    return secret;
  }

  Map<String, dynamic> toJson({bool isEncrypted = true}) {
    final Map<String, dynamic> dataMap = _$SecretToJson(this);

    if (isEncrypted) {
      dataMap.encrypt();
    }

    return dataMap;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secretum/utils/utils.dart';

/// [FirestoreMetadata] is a superclass which gathers [DocumentSnapshot] and [DocumentChangeType] inside.
/// They are used for Firestore specific functionality/queries.
///
/// [FirestoreMetadata] must be extended by every collection/sub-collection object model from Firestore.
@JsonSerializable(createFactory: false, createToJson: false)
abstract class FirestoreMetadata {
  @JsonKey(ignore: true)
  late DocumentSnapshot documentSnapshot;
  @JsonKey(ignore: true)
  DocumentChangeType? documentChangeType;

  /// Every single Firestore document must have [createdAt] field
  @JsonKey(fromJson: Utils.dateTimeFromISO, toJson: Utils.dateTimeToISO)
  DateTime createdAt;

  FirestoreMetadata({required this.createdAt});
}

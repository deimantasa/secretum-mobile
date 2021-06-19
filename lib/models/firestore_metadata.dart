import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// [FirestoreMetadata] is a superclass which gathers [DocumentSnapshot] and [DocumentChangeType] inside.
/// They are used for Firestore specific functionality/queries.
/// [FirestoreMetadata] fields will always be ignored once submitting data to Firestore.
///
/// [FirestoreMetadata] must be extended by every collection/sub-collection object model from Firestore.
@JsonSerializable(createFactory: false, createToJson: false)
abstract class FirestoreMetadata {
  @JsonKey(ignore: true)
  late DocumentSnapshot documentSnapshot;
  @JsonKey(ignore: true)
  DocumentChangeType? documentChangeType;

  FirestoreMetadata();
}

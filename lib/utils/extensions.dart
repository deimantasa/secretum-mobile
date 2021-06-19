import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/firestore_metadata.dart';
import 'package:secretum/services/encryption_service.dart';

// Use locally defined EncryptionService due to limitations of json_serializable
// (cannot pass correctly this variable so that raw data is encrypted/decrypted).
final EncryptionService _encryptionService = GetIt.instance<EncryptionService>();

extension MapExtension on Map<String, dynamic> {
  void encrypt() {
    this.forEach((key, value) {
      if (value is String && value.isNotEmpty) {
        this[key] = _encryptionService.getEncryptedText(value);
      }
    });
  }

  void decrypt() {
    this.forEach((key, value) {
      if (value is String && value.isNotEmpty) {
        this[key] = _encryptionService.getDecryptedText(value);
      }
    });
  }

  void hash() {
    this.forEach((key, value) {
      if (value is String && value.isNotEmpty) {
        this[key] = _encryptionService.getHashedText(value);
      }
    });
  }
}

extension FirestoreMetadataExtension on List<FirestoreMetadata> {
  /// Extension helper method which acts as a universal [onAdded] function for
  /// firestore listener stream.
  /// [givenElement] is an element spit out from firestore stream.
  /// [onViewUpdate] is a function which will update UI.
  /// [onSort] is a function, which will sometimes is used to sort list, if item is newly added
  /// so the order wouldn't be messed up.
  void onAdded<T extends FirestoreMetadata>(
    T givenElement, {
    required String logReference,
    required Function onViewUpdate,
    void Function(List<T>)? onSort,
  }) {
    bool exists = this.any((element) => element.documentSnapshot.id == givenElement.documentSnapshot.id);
    if (!exists) {
      this.add(givenElement);
      //If there is already exist several items and new item is added, make sure it goes to the right place in the
      //list by sorting it
      if (onSort != null) onSort(this as List<T>);
      onViewUpdate();

      loggingService.log('onAdded.$logReference: ${givenElement.documentSnapshot.id}');
    }
  }

  /// Extension helper method which acts as a universal [onModified] function for
  /// firestore listener stream.
  /// [givenElement] is an element spit out from firestore stream.
  /// [onViewUpdate] is a function which will update UI.
  /// [onSort] is a function, which will sometimes is used to sort list, if item is modified
  /// so the order wouldn't be messed up.
  void onModified<T extends FirestoreMetadata>(
    T givenElement, {
    required String logReference,
    required Function onViewUpdate,
    void Function(List<T>)? onSort,
  }) {
    for (int i = 0; i < this.length; i++) {
      if (this[i].documentSnapshot.id == givenElement.documentSnapshot.id) {
        this[i] = givenElement;
        if (onSort != null) onSort(this as List<T>);
        onViewUpdate();

        loggingService.log('onModified.$logReference: ${givenElement.documentSnapshot.id}');
        break;
      }
    }
  }

  /// Extension helper method which acts as a universal [onRemoved] function for
  /// firestore listener stream.
  /// [givenElement] is an element spit out from firestore stream.
  /// [onViewUpdate] is a function which will update UI.
  void onRemoved<T extends FirestoreMetadata>(
    T givenElement, {
    required String logReference,
    required Function onViewUpdate,
  }) {
    this.removeWhere((element) => givenElement.documentSnapshot.id == element.documentSnapshot.id);

    loggingService.log('onRemoved.$logReference: ${givenElement.documentSnapshot.id}');
    onViewUpdate();
  }
}

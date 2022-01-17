import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/pages/authentication/authentication_contract.dart';
import 'package:secretum/pages/backup_preview/backup_preview_contract.dart';
import 'package:secretum/pages/edit_entry/edit_entry_contract.dart';
import 'package:secretum/pages/home/home_contract.dart';
import 'package:secretum/pages/home/home_presenter.dart';
import 'package:secretum/services/authentication_service.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/logging_service.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'mock_function.dart';

@GenerateMocks([
  LoggingService,
  Secret,
  DocumentSnapshot,
  DocumentChange,
  UsersSensitiveInformation,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  StreamSubscription,
  AuthenticationView,
  AuthenticationService,
  BackupPreviewView,
  EditEntryView,
  EncryptionService,
  UsersStore,
  HomeView,
  HomePresenterHelper,
  StorageService,
  SecretsStore,
], customMocks: [
  MockSpec<FunctionMock>(as: #MockFunction),
])
void main() {}

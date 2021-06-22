import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/services/logging_service.dart';

import 'mock_function.dart';

@GenerateMocks([
  LoggingService,
  DbBackup,
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
], customMocks: [
  MockSpec<FunctionMock>(as: #MockFunction),
])
void main() {}

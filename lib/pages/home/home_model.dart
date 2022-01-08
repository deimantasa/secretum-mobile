import 'package:secretum/models/loading_state.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/user.dart';

class HomeModel {
  final LoadingState loadingState = LoadingState.notLoading();
  User? user;
  List<Secret> secrets = [];
}

import 'package:secretum/models/loading_state.dart';
import 'package:secretum/models/secret.dart';

class HomeModel {
  final LoadingState loadingState = LoadingState.notLoading();
  List<Secret> secrets = [];
}

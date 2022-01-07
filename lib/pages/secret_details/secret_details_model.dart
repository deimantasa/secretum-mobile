import 'package:secretum/models/loading_state.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/user.dart';

class SecretDetailsModel {
  final LoadingState loadingState = LoadingState.notLoading();
  final String secretId;
  late User user;
  Secret? secret;

  SecretDetailsModel(this.secretId);
}

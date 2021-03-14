import 'package:secretum/models/clickable.dart';

class LandingModel {
  final durationThreshold = Duration(seconds: 6);

  DateTime clickStartTime = DateTime.now();
  Clickable topLeftClickable = Clickable.topLeft();
  Clickable topRightClickable = Clickable.topRight();
  Clickable bottomCenterClickable = Clickable.bottomCenter();
}

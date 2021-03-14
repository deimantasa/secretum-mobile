import 'package:json_annotation/json_annotation.dart';

part 'clickable.g.dart';

@JsonSerializable()
class Clickable {
  late int clickThreshold;
  late int currentClickCount;

  Clickable(this.clickThreshold, this.currentClickCount);

  Clickable.topLeft() {
    this.clickThreshold = 3;
    this.currentClickCount = 0;
  }

  Clickable.topRight() {
    this.clickThreshold = 3;
    this.currentClickCount = 0;
  }

  Clickable.bottomCenter() {
    this.clickThreshold = 3;
    this.currentClickCount = 0;
  }

  bool isQualifying() {
    return clickThreshold == currentClickCount;
  }

  factory Clickable.fromJson(Map<String, dynamic> json) => _$ClickableFromJson(json);
  Map<String, dynamic> toJson() => _$ClickableToJson(this);
}

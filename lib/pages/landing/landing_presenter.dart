import 'package:flutter/material.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/clickable.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:secretum/utils/utils.dart';
import 'package:provider/provider.dart';

import 'landing_contract.dart';
import 'landing_model.dart';

class LandingPresenter implements Presenter {
  late final View _view;
  late final LandingModel _landingModel;

  late final UsersStore _usersStore;

  LandingPresenter(View view, BuildContext context, LandingModel landingModel) {
    _view = view;
    _landingModel = landingModel;

    _usersStore = context.read<UsersStore>();
  }

  void _resetEverything() {
    _landingModel.clickStartTime = DateTime.now();
    _landingModel.topLeftClickable = Clickable.topLeft();
    _landingModel.topRightClickable = Clickable.topRight();
    _landingModel.bottomCenterClickable = Clickable.bottomCenter();

    _view.updateView();
  }

  @override
  Future<void> verifyClickThrough() async {
    DateTime currentTime = DateTime.now();

    if (currentTime.difference(_landingModel.clickStartTime) <= _landingModel.durationThreshold &&
        _landingModel.topLeftClickable.isQualifying() &&
        _landingModel.topRightClickable.isQualifying() &&
        _landingModel.bottomCenterClickable.isQualifying()) {
      _view.showPasswordInputDialog();
    }

    // It doesn't matter validation is success or failed
    // once we click the button - we reset everything.
    _resetEverything();
  }

  @override
  void updateClickable(Clickable clickable) {
    clickable.currentClickCount += 1;

    if (clickable.currentClickCount > clickable.clickThreshold) {
      _resetEverything();
    }

    _view.updateView();
  }

  @override
  void verifyPassword(String password) async {
    if (_usersStore.user != null) {
      if (encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.primaryPassword) {
        bool isSuccess = await Utils.authViaBiometric();
        if (isSuccess) {
          await _usersStore.initUserOnAppStart();
          _view.goToHomePage();
        }
      }

      //Doesn't matter of the outcome - reset everything once verifying password is triggered
      _resetEverything();
    }
  }
}

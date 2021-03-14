import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/pages/secret_details/secret_details_page.dart';
import 'package:secretum/pages/welcome/welcome_page.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:provider/provider.dart';

import 'home_contract.dart';
import 'home_model.dart';
import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  final bool isFirstTime;

  const HomePage({
    Key? key,
    required this.isFirstTime,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements View {
  late final HomeModel _homeModel;
  late final HomePresenter _homePresenter;

  @override
  void initState() {
    _homeModel = HomeModel();
    _homePresenter = HomePresenter(this, context, _homeModel);
    _homePresenter.init();

    if (widget.isFirstTime) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        Dialogs.showSecretKeyBottomSheet(context);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<UsersStore>();
    context.watch<SecretsStore>();

    _homePresenter.updateData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Secretum"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are you sure you want to sign-out?"),
                      actions: [
                        TextButton(
                          child: Text("No"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () => _homePresenter.signOut(),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: _buildBodyWidget(),
    );
  }

  @override
  void showMessage(String message, {bool isSuccess = true}) {
    Dialogs.showMessage(context, message: message, isSuccess: isSuccess);
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }

  Widget _buildBodyWidget() {
    if (_homeModel.secrets.isEmpty) {
      return Center(
        child: ElevatedButton(
          child: Text("Add new secret"),
          onPressed: () => _showAddNewWalletBottomSheet(),
        ),
      );
    } else {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              //Make sure ListView items are not hidden by FABs
              padding: EdgeInsets.only(bottom: 90),
              itemCount: _homeModel.secrets.length,
              itemBuilder: (context, index) {
                Secret secret = _homeModel.secrets[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        "${secret.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        String? password = await Dialogs.showPasswordConfirmationDialog(
                          context,
                          hintText: "Secondary Password",
                        );

                        if (password != null) {
                          if (_homePresenter.isPasswordMatch(password)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecretDetailsPage(secretId: secret.documentSnapshot!.id),
                              ),
                            );
                          } else {
                            showMessage("Password is invalid", isSuccess: false);
                          }
                        }
                        //If password is null, then user just dismissed dialog themselves
                        //Do nothing
                      },
                    ),
                    Divider(height: 1),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.download_rounded),
                    onPressed: () async {
                      String? fileName = await Dialogs.showEditEntryBottomSheet(
                        context,
                        title: "Export File",
                        description: "All your secrets will be exported in one file in your phone.",
                        hintText: "Enter file name",
                        entry: "",
                        buttonText: "Export",
                        textCapitalization: TextCapitalization.none,
                        validateWithPrimaryPassword: false,
                        validateWithSecondaryPassword: false,
                        validateWithBiometric: true,
                      );

                      if (fileName != null && fileName.isNotEmpty) {
                        _homePresenter.exportSecrets(fileName);
                      }
                    },
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.add),
                    onPressed: () => _showAddNewWalletBottomSheet(),
                  )
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  Future<void> _showAddNewWalletBottomSheet() async {
    String? secretsName = await Dialogs.showEditEntryBottomSheet(
      context,
      title: "Enter Secret's Name",
      hintText: "eg. Binance Key",
      entry: "",
      buttonText: "Add",
      textCapitalization: TextCapitalization.words,
      validateWithPrimaryPassword: false,
      validateWithSecondaryPassword: false,
      validateWithBiometric: true,
    );

    if (secretsName != null && secretsName.isNotEmpty) {
      _homePresenter.addNewSecret(secretsName);
    }
  }

  @override
  void goToWelcomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
      (route) => false,
    );
  }

  @override
  void showMessageDialog(String fileLocation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Export Success"),
          content: Text("File location: $fileLocation"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}

import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secretum/models/enums/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/pages/backup_preview/backup_preview_page.dart';
import 'package:secretum/pages/secret_details/secret_details_page.dart';
import 'package:secretum/pages/welcome/welcome_page.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:secretum/utils/app_assets.dart';
import 'package:secretum/utils/app_colors.dart';
import 'package:secretum/utils/utils.dart';

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

class _HomePageState extends State<HomePage> implements HomeView {
  late final HomeModel _model;
  late final HomePresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = HomeModel();
    _presenter = HomePresenter(this, _model);
    _presenter.init();

    if (widget.isFirstTime) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        Dialogs.showSecretKeyBottomSheet(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<UsersStore>();
    context.watch<SecretsStore>();

    _presenter.updateData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Secretum'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add),
        onPressed: () => _showAddNewSecretBottomSheet(),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  @override
  void showMessage(String message, {bool isSuccess = true}) {
    Dialogs.showMessage(message: message, isSuccess: isSuccess);
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }

  Widget _buildBody() {
    if (_model.secrets.isEmpty) {
      return Center(
        child: ElevatedButton(
          child: Text('Add new secret'),
          onPressed: () => _showAddNewSecretBottomSheet(),
        ),
      );
    } else {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              // Make sure ListView items are not hidden by FABs
              padding: EdgeInsets.only(bottom: 90),
              itemCount: _model.secrets.length,
              itemBuilder: (context, index) {
                final Secret secret = _model.secrets[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        '${secret.name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(Utils.getFormattedDate(secret.createdAt)),
                      onTap: () => _goToSecretDetailsPage(secret),
                    ),
                    Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Future<void> _showAddNewSecretBottomSheet() async {
    final String? secretsName = await Dialogs.showEditEntryBottomSheet(
      context,
      title: "Enter Secret's Name",
      hintText: 'eg. Monero seed',
      entry: '',
      buttonText: 'Add',
      textCapitalization: TextCapitalization.words,
      validator: (text) => text != null && text.isNotEmpty ? null : 'Secret cannot be empty',
      validateWithPrimaryPassword: false,
      validateWithBiometric: true,
    );

    if (secretsName != null && secretsName.isNotEmpty) {
      _presenter.addNewSecret(secretsName);
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
          title: Text('Export Success'),
          content: Text('File location: $fileLocation'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Widget _buildDrawer() {
    const double kImageSize = 80;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Spacer(),
                      SvgPicture.asset(
                        AppAssets.kSecretumLogo,
                        width: kImageSize,
                        height: kImageSize,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'SECRETUM',
                        style: TextStyle(
                          color: AppColors.kMaterialColor1,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.download_rounded),
            title: Text('Backup from DB'),
            onTap: () async {
              final String? fileName = await Dialogs.showEditEntryBottomSheet(
                context,
                title: 'Export File',
                description:
                    'All your secrets will be exported from the database to the text file in your phone. Text file is fully encrypted.',
                hintText: 'Enter file name',
                entry: '',
                buttonText: 'Export',
                textCapitalization: TextCapitalization.none,
                validator: (text) => text != null && text.isNotEmpty ? null : 'File name cannot be empty',
                validateWithPrimaryPassword: false,
                validateWithBiometric: true,
              );

              if (fileName != null && fileName.isNotEmpty) {
                _presenter.exportSecrets(ExportFromType.database, fileName);
              }
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.folder_rounded),
            title: Text('Open Exported Backups'),
            onTap: () async {
              final Directory directory = await getApplicationDocumentsDirectory();

              final String? path = await FilesystemPicker.open(
                title: 'Exported Backups',
                context: context,
                rootDirectory: directory,
                fsType: FilesystemType.file,
                allowedExtensions: ['.txt'],
                fileTileSelectMode: FileTileSelectMode.wholeTile,
                folderIconColor: Colors.teal,
              );

              if (path != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BackupPreviewPage(pathToFile: path)));
              }
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.auto_delete),
            title: Text('Delete Backups'),
            onTap: () => _showDeleteBackupsDialog(),
          ),
          Divider(height: 1),
          ListTile(),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log-Out'),
            onTap: () => _showLogOutDialog(),
          ),
          Divider(height: 1),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    return Text(
                      "App Version: ${snapshot.data != null ? snapshot.data!.version : ""}",
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _goToSecretDetailsPage(Secret secret) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecretDetailsPage(secretId: secret.id)),
    );
  }

  void _showLogOutDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure you want to log-out?'),
            content: Text('Make sure you have your secret key saved. This will be the only way to log-in to your account again.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  'Log-Out',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => _presenter.signOut(),
              ),
            ],
          );
        });
  }

  void _showDeleteBackupsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete all backups'),
          content: Text('It will delete all your locally saved backup files from your device.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Delete Backups',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Close previous dialog
                Navigator.pop(context);

                _presenter.deleteBackups();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/enums/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/pages/backup_preview/backup_preview_page.dart';
import 'package:secretum/pages/secret_details/secret_details_page.dart';
import 'package:secretum/pages/welcome/welcome_page.dart';
import 'package:secretum/stores/db_backup_store.dart';
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
  late final HomeModel _homeModel;
  late final HomePresenter _homePresenter;

  @override
  void initState() {
    super.initState();

    _homeModel = HomeModel();
    _homePresenter = HomePresenter(this, _homeModel);
    _homePresenter.init();

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
    context.watch<DbBackupStore>();

    _homePresenter.updateData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Secretum'),
        actions: [],
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
    if (_homeModel.secrets.isEmpty) {
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
              itemCount: _homeModel.secrets.length,
              itemBuilder: (context, index) {
                Secret secret = _homeModel.secrets[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                        title: Text(
                          '${secret.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('${Utils.getFormattedDate(secret.createdAt)}'),
                        onTap: () async => _goToSecretDetailsPage(secret)),
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
      hintText: 'eg. Binance Key',
      entry: '',
      buttonText: 'Add',
      textCapitalization: TextCapitalization.words,
      validator: (text) => text != null && text.isNotEmpty ? null : 'Secret cannot be empty',
      validateWithPrimaryPassword: false,
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
    final DbBackup? dbBackup = _homeModel.dbBackup;

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
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup'),
            subtitle:
                Text(dbBackup == null ? 'Not backed up yet' : 'Last backup: ${Utils.getFormattedDate(dbBackup.backupDate)}'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Save snapshot from DB locally'),
                    content: Text(
                        'Once backed up, your database records will be saved into encrypted local database.\n\nBackups are stored only locally on your device.'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text(
                          'Backup',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () async {
                          //Close previous dialog
                          Navigator.pop(context);

                          _homePresenter.saveDbLocally();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // Only show local export if db backup is available
          if (dbBackup != null) ...[
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.download_rounded),
              title: Text('Export from Backup'),
              onTap: () async {
                final String? fileName = await Dialogs.showEditEntryBottomSheet(
                  context,
                  title: 'Export File',
                  description: 'All your secrets will be exported from backup to the text file in your phone.',
                  hintText: 'Enter file name',
                  entry: '',
                  buttonText: 'Export',
                  textCapitalization: TextCapitalization.none,
                  validator: (text) => text != null && text.isNotEmpty ? null : 'File name cannot be empty',
                  validateWithPrimaryPassword: false,
                  validateWithBiometric: true,
                );

                if (fileName != null && fileName.isNotEmpty) {
                  _homePresenter.exportSecrets(ExportFromType.backup, fileName);
                }
              },
            ),
          ],
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.download_rounded),
            title: Text('Export from DB'),
            onTap: () async {
              final String? fileName = await Dialogs.showEditEntryBottomSheet(
                context,
                title: 'Export File',
                description: 'All your secrets will be exported from the database to the text file in your phone.',
                hintText: 'Enter file name',
                entry: '',
                buttonText: 'Export',
                textCapitalization: TextCapitalization.none,
                validator: (text) => text != null && text.isNotEmpty ? null : 'File name cannot be empty',
                validateWithPrimaryPassword: false,
                validateWithBiometric: true,
              );

              if (fileName != null && fileName.isNotEmpty) {
                _homePresenter.exportSecrets(ExportFromType.database, fileName);
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
            leading: Icon(Icons.logout),
            title: Text('Log-Out'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to log-out?'),
                      content: Text(
                          'Make sure you have your secret key saved. This will be the only way to log-in to your account again.'),
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
                          onPressed: () => _homePresenter.signOut(),
                        ),
                      ],
                    );
                  });
            },
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
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
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
      MaterialPageRoute(
        builder: (context) => SecretDetailsPage(secretId: secret.documentSnapshot.id),
      ),
    );
  }
}

import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:procam_commander/widgets/camera_preset_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;

import '../models/camera.dart';
import '../models/projector.dart';
import '../theme.dart';
import '../widgets/page.dart';
import '../widgets/list_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with PageMixin {
  final spacer = const SizedBox(height: 10.0);
  final biggerSpacer = const SizedBox(height: 40.0);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController _userProjectorTextController =
      TextEditingController();
  final TextEditingController _passwordProjectorTextController =
      TextEditingController();
  final TextEditingController _ipProjectorTextController =
      TextEditingController();
  final TextEditingController _ipCameraTextController = TextEditingController();
  final TextEditingController _userCameraTextController =
      TextEditingController();
  final TextEditingController _passwordCameraTextController =
      TextEditingController();

  late final FocusNode _ipProjectorFocusNode;
  late final FocusNode _ipCameraFocusNode;
  late final FocusNode _userProjectorFocusNode;
  late final FocusNode _passwordProjectorFocusNode;
  late final FocusNode _userCameraFocusNode;
  late final FocusNode _passwordCameraFocusNode;

  String _userProjector = '';
  String _passwordProjector = '';
  String _ipProjector = '';
  String _userCamera = '';
  String _passwordCamera = '';
  String _ipCamera = '';

  void _saveValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void _saveCredentialsProjector() {
    if (_userProjectorTextController.text != _userProjector) {
      _userProjector = _userProjectorTextController.text;
      _saveValue('userProjector', _userProjector);
      Provider.of<Projector>(context, listen: false).onSettingsChanged();
    }
    if (_passwordProjectorTextController.text != _passwordProjector) {
      _passwordProjector = _passwordProjectorTextController.text;
      _saveValue('passwordProjector', _passwordProjector);
      Provider.of<Projector>(context, listen: false).onSettingsChanged();
    }
  }

  void _saveCredentialsCamera() {
    if (_userCameraTextController.text != _userCamera) {
      _userCamera = _userCameraTextController.text;
      _saveValue('userCamera', _userCamera);
      Provider.of<Camera>(context, listen: false).onSettingsChanged();
    }
    if (_passwordCameraTextController.text != _passwordCamera) {
      _passwordCamera = _passwordCameraTextController.text;
      _saveValue('passwordCamera', _passwordCamera);
      Provider.of<Camera>(context, listen: false).onSettingsChanged();
    }
  }

  void _saveIpCamera() {
    if (_ipCameraTextController.text == _ipCamera) return;

    _ipCamera = _ipCameraTextController.text;
    _saveValue('ipCamera', _ipCamera);
    Provider.of<Camera>(context, listen: false).onSettingsChanged();
  }

  void _saveIpProjector() {
    if (_ipProjectorTextController.text == _ipProjector) return;

    _ipProjector = _ipProjectorTextController.text;
    _saveValue('ipProjector', _ipProjector);
    Provider.of<Projector>(context, listen: false).onSettingsChanged();
  }

  @override
  void initState() {
    _userProjectorFocusNode = FocusNode(debugLabel: 'userProjectorFocusNode');
    _passwordProjectorFocusNode =
        FocusNode(debugLabel: 'passwordProjectorFocusNode');
    _ipCameraFocusNode = FocusNode(debugLabel: 'ipCameraFocusNode');
    _userCameraFocusNode = FocusNode(debugLabel: 'userCameraFocusNode');
    _passwordCameraFocusNode = FocusNode(debugLabel: 'passwordCameraFocusNode');
    _ipProjectorFocusNode = FocusNode(debugLabel: 'ipProjectorFocusNode');

    _userProjectorFocusNode.addListener(_saveCredentialsProjector);
    _passwordProjectorFocusNode.addListener(_saveCredentialsProjector);
    _ipCameraFocusNode.addListener(_saveIpCamera);
    _userCameraFocusNode.addListener(_saveCredentialsCamera);
    _passwordCameraFocusNode.addListener(_saveCredentialsCamera);
    _ipProjectorFocusNode.addListener(_saveIpProjector);

    _prefs.then((SharedPreferences prefs) {
      _userProjector = prefs.getString('userProjector') ?? '';
      _userProjectorTextController.text = _userProjector;
      _passwordProjector = prefs.getString('passwordProjector') ?? '';
      _passwordProjectorTextController.text = _passwordProjector;
      _ipProjector = prefs.getString('ipProjector') ?? '';
      _ipProjectorTextController.text = _ipProjector;

      _userCamera = prefs.getString('userCamera') ?? '';
      _userCameraTextController.text = _userCamera;
      _passwordCamera = prefs.getString('passwordCamera') ?? '';
      _passwordCameraTextController.text = _passwordCamera;
      _ipCamera = prefs.getString('ipCamera') ?? '';
      _ipCameraTextController.text = _ipCamera;
    });
    super.initState();
  }

  @override
  void dispose() {
    _userProjectorFocusNode.removeListener(_saveCredentialsProjector);
    _passwordProjectorFocusNode.removeListener(_saveCredentialsProjector);
    _ipCameraFocusNode.removeListener(_saveIpCamera);
    _ipProjectorFocusNode.removeListener(_saveIpProjector);
    _userCameraFocusNode.removeListener(_saveCredentialsCamera);
    _passwordCameraFocusNode.removeListener(_saveCredentialsCamera);

    _userProjectorFocusNode.dispose();
    // _passwordProjectorFocusNode is already disposed somehow.
    // This has so.th. to do with the used PasswordBox widget.
    // _passwordProjectorFocusNode.dispose();
    _ipCameraFocusNode.dispose();
    _ipProjectorFocusNode.dispose();
    _userCameraFocusNode.dispose();
    // _passwordCameraFocusNode is already disposed somehow.
    // This has so.th. to do with the used PasswordBox widget.
    // _passwordCameraFocusNode.dispose();
    _userProjectorTextController.dispose();
    _passwordProjectorTextController.dispose();
    _ipCameraTextController.dispose();
    _ipProjectorTextController.dispose();
    _userCameraTextController.dispose();
    _passwordCameraTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Einstellungen')),
      children: [
        Text('Darstellung', style: FluentTheme.of(context).typography.subtitle),
        spacer,
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.dark_theme_20_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farbschema',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: ComboBox<String>(
                  value: appTheme.mode.name,
                  items: List.generate(ThemeMode.values.length, (index) {
                    final mode = ThemeMode.values[index];
                    return ComboBoxItem(
                      key: ValueKey(mode.name),
                      value: mode.name,
                      child: Text(mode.name),
                    );
                  }),
                  onChanged: (selectedValue) => appTheme.mode = ThemeMode.values
                      .firstWhere((element) => selectedValue == element.name),
                ),
              ),
            ],
          ),
        ),
        biggerSpacer,
        Text('Geräte', style: FluentTheme.of(context).typography.subtitle),
        spacer,
        Text('Beamer', style: FluentTheme.of(context).typography.bodyStrong),
        spacer,
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.password_24_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anmeldedaten',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: TextBox(
                  placeholder: 'Benutzername',
                  expands: false,
                  focusNode: _userProjectorFocusNode,
                  controller: _userProjectorTextController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 150,
                child: PasswordBox(
                  placeholder: 'Passwort',
                  revealMode: PasswordRevealMode.hidden,
                  focusNode: _passwordProjectorFocusNode,
                  controller: _passwordProjectorTextController,
                ),
              ),
            ],
          ),
        ),
        spacer,
        ListCard(
          child: InfoLabel(
            label: 'IP-Adresse',
            child: TextBox(
              placeholder: '0.0.0.0',
              expands: false,
              focusNode: _ipProjectorFocusNode,
              controller: _ipProjectorTextController,
            ),
          ),
        ),
        spacer,
        Text('Kamera', style: FluentTheme.of(context).typography.bodyStrong),
        spacer,
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.password_24_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anmeldedaten',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: TextBox(
                  placeholder: 'Benutzername',
                  expands: false,
                  focusNode: _userCameraFocusNode,
                  controller: _userCameraTextController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 150,
                child: PasswordBox(
                  placeholder: 'Passwort',
                  revealMode: PasswordRevealMode.hidden,
                  focusNode: _passwordCameraFocusNode,
                  controller: _passwordCameraTextController,
                ),
              ),
            ],
          ),
        ),
        spacer,
        ListCard(
          child: InfoLabel(
            label: 'IP-Adresse',
            child: TextBox(
              placeholder: '0.0.0.0',
              expands: false,
              focusNode: _ipCameraFocusNode,
              controller: _ipCameraTextController,
            ),
          ),
        ),
        // *******************************************************
        biggerSpacer,
        const CameraPresetList(),
      ],
    );
  }
}

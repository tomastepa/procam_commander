import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;

import '../models/camera.dart';
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
  int? _defaultPosition,
      _speakerPosition,
      _readerPosition,
      _studentAssignmentPosition;

  void _saveValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    // print('Saved: $key $value');
  }

  void _saveCredentialsProjector() {
    if (_userProjectorTextController.text != _userProjector) {
      _userProjector = _userProjectorTextController.text;
      _saveValue('userProjector', _userProjector);
    }
    if (_passwordProjectorTextController.text != _passwordProjector) {
      _passwordProjector = _passwordProjectorTextController.text;
      _saveValue('passwordProjector', _passwordProjector);
    }
  }

  void _saveCredentialsCamera() {
    if (_userCameraTextController.text != _userCamera) {
      _userCamera = _userCameraTextController.text;
      _saveValue('userCamera', _userCamera);
    }
    if (_passwordCameraTextController.text != _passwordCamera) {
      _passwordCamera = _passwordCameraTextController.text;
      _saveValue('passwordCamera', _passwordCamera);
    }
  }

  void _saveIpCamera() {
    if (_ipCameraTextController.text == _ipCamera) return;

    _ipCamera = _ipCameraTextController.text;
    _saveValue('ipCamera', _ipCamera);
  }

  void _saveIpProjector() {
    if (_ipProjectorTextController.text == _ipProjector) return;

    _ipProjector = _ipProjectorTextController.text;
    _saveValue('ipProjector', _ipProjector);
  }

  void _savePreset(String position, int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value == null) {
      prefs.remove(position);
    } else {
      prefs.setInt(position, value);
    }
  }

  void _savePresetDefault(int? value) {
    if (_defaultPosition == value) return;
    _savePreset('defaultCameraPosition', value);
    setState(() => _defaultPosition = value);
    Provider.of<Camera>(context, listen: false).fetchPresets();
  }

  void _savePresetSpeaker(int? value) {
    if (_speakerPosition == value) return;
    _savePreset('speakerCameraPosition', value);
    setState(() => _speakerPosition = value);
    Provider.of<Camera>(context, listen: false).fetchPresets();
  }

  void _savePresetReader(int? value) {
    if (_readerPosition == value) return;
    _savePreset('readerCameraPosition', value);
    setState(() => _readerPosition = value);
    Provider.of<Camera>(context, listen: false).fetchPresets();
  }

  void _savePresetStudentAssignment(int? value) {
    if (_studentAssignmentPosition == value) return;
    _savePreset('studentAssignmentCameraPosition', value);
    setState(() => _studentAssignmentPosition = value);
    Provider.of<Camera>(context, listen: false).fetchPresets();
  }

  @override
  void initState() {
    super.initState();
    _userProjectorFocusNode = FocusNode();
    _passwordProjectorFocusNode = FocusNode();
    _ipCameraFocusNode = FocusNode();
    _userCameraFocusNode = FocusNode();
    _passwordCameraFocusNode = FocusNode();
    _ipProjectorFocusNode = FocusNode();

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
      _passwordCameraTextController.text = _passwordProjector;
      _ipCamera = prefs.getString('ipCamera') ?? '';
      _ipCameraTextController.text = _ipCamera;

      setState(() {
        _defaultPosition = prefs.getInt('defaultCameraPosition');
        _speakerPosition = prefs.getInt('speakerCameraPosition');
        _readerPosition = prefs.getInt('readerCameraPosition');
        _studentAssignmentPosition =
            prefs.getInt('studentAssignmentCameraPosition');
      });
    });
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
    _passwordProjectorFocusNode.dispose();
    _ipCameraFocusNode.dispose();
    _ipProjectorFocusNode.dispose();
    _userCameraFocusNode.dispose();
    _passwordCameraFocusNode.dispose();
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
        ...List.generate(ThemeMode.values.length, (index) {
          final mode = ThemeMode.values[index];
          return Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: RadioButton(
              checked: appTheme.mode == mode,
              onChanged: (value) {
                if (value) {
                  appTheme.mode = mode;
                }
              },
              content: Text('$mode'.replaceAll('ThemeMode.', '')),
            ),
          );
        }),
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
              placeholder: '192.168.0.100',
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
              placeholder: '192.168.0.100',
              expands: false,
              focusNode: _ipCameraFocusNode,
              controller: _ipCameraTextController,
            ),
          ),
        ),
        spacer,
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.home_24_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: NumberBox(
                  mode: SpinButtonPlacementMode.inline,
                  value: _defaultPosition,
                  onChanged: _savePresetDefault,
                  min: 1,
                  max: 255,
                ),
              ),
            ],
          ),
        ),
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.presenter_24_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Redner',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: NumberBox(
                  mode: SpinButtonPlacementMode.inline,
                  value: _speakerPosition,
                  onChanged: _savePresetSpeaker,
                  min: 1,
                  max: 255,
                ),
              ),
            ],
          ),
        ),
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.person_standing_16_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leser',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: NumberBox(
                  mode: SpinButtonPlacementMode.inline,
                  value: _readerPosition,
                  onChanged: _savePresetReader,
                  min: 1,
                  max: 255,
                ),
              ),
            ],
          ),
        ),
        ListCard(
          child: Row(
            children: [
              const Icon(ms_icons.FluentIcons.people_24_regular),
              const SizedBox(width: 10.0),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Studierendenaufgabe',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 150,
                child: NumberBox(
                  mode: SpinButtonPlacementMode.inline,
                  value: _studentAssignmentPosition,
                  // focusNode: _ipProjectorFocusNode,
                  onChanged: _savePresetStudentAssignment,
                  min: 1,
                  max: 255,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

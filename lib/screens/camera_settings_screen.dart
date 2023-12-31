import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/camera.dart';
import '../widgets/camera_preset_list.dart';
import '../widgets/list_card.dart';

class CameraSettingsScreen extends StatefulWidget {
  const CameraSettingsScreen({super.key});

  @override
  State<CameraSettingsScreen> createState() => _CameraSettingsScreenState();
}

class _CameraSettingsScreenState extends State<CameraSettingsScreen> {
  final spacer = const SizedBox(height: 10.0);
  final biggerSpacer = const SizedBox(height: 40.0);

  final breadcrumbItems = <BreadcrumbItem<int>>[
    const BreadcrumbItem(label: Text('Einstellungen'), value: 0),
    const BreadcrumbItem(label: Text('Kamera'), value: 1),
  ];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController _ipCameraTextController = TextEditingController();
  final TextEditingController _userCameraTextController =
      TextEditingController();
  final TextEditingController _passwordCameraTextController =
      TextEditingController();

  late final FocusNode _ipCameraFocusNode;
  late final FocusNode _userCameraFocusNode;
  late final FocusNode _passwordCameraFocusNode;

  String _userCamera = '';
  String _passwordCamera = '';
  String _ipCamera = '';

  void _saveValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
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

  @override
  void initState() {
    _ipCameraFocusNode = FocusNode(debugLabel: 'ipCameraFocusNode');
    _userCameraFocusNode = FocusNode(debugLabel: 'userCameraFocusNode');
    _passwordCameraFocusNode = FocusNode(debugLabel: 'passwordCameraFocusNode');

    _ipCameraFocusNode.addListener(_saveIpCamera);
    _userCameraFocusNode.addListener(_saveCredentialsCamera);
    _passwordCameraFocusNode.addListener(_saveCredentialsCamera);

    _prefs.then((SharedPreferences prefs) {
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
    _ipCameraFocusNode.removeListener(_saveIpCamera);
    _userCameraFocusNode.removeListener(_saveCredentialsCamera);
    _passwordCameraFocusNode.removeListener(_saveCredentialsCamera);

    _ipCameraFocusNode.dispose();
    _userCameraFocusNode.dispose();
    // _passwordCameraFocusNode is already disposed somehow.
    // This has so.th. to do with the used PasswordBox widget.
    // _passwordCameraFocusNode.dispose();
    _ipCameraTextController.dispose();
    _userCameraTextController.dispose();
    _passwordCameraTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: BreadcrumbBar<int>(
          items: breadcrumbItems,
          onItemPressed: (_) {
            context.pop();
          },
        ),
      ),
      children: [
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
              const SizedBox(width: 10),
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
        biggerSpacer,
        Text(
          'Positionen',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        spacer,
        const CameraPresetList(),
      ],
    );
  }
}

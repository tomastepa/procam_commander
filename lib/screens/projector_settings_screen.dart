import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/projector.dart';
import '../widgets/list_card.dart';

class ProjectorSettingsScreen extends StatefulWidget {
  const ProjectorSettingsScreen({super.key});

  @override
  State<ProjectorSettingsScreen> createState() =>
      _ProjectorSettingsScreenState();
}

class _ProjectorSettingsScreenState extends State<ProjectorSettingsScreen> {
  final spacer = const SizedBox(height: 10.0);
  final biggerSpacer = const SizedBox(height: 40.0);

  final breadcrumbItems = <BreadcrumbItem<int>>[
    const BreadcrumbItem(label: Text('Einstellungen'), value: 0),
    const BreadcrumbItem(label: Text('Beamer'), value: 1),
  ];

  final Future<SharedPreferencesWithCache> _prefs =
      SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  final TextEditingController _userProjectorTextController =
      TextEditingController();
  final TextEditingController _passwordProjectorTextController =
      TextEditingController();
  final TextEditingController _ipProjectorTextController =
      TextEditingController();

  late final FocusNode _ipProjectorFocusNode;
  late final FocusNode _userProjectorFocusNode;
  late final FocusNode _passwordProjectorFocusNode;

  String _userProjector = '';
  String _passwordProjector = '';
  String _ipProjector = '';

  void _saveValue(String key, String value) async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
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
    _ipProjectorFocusNode = FocusNode(debugLabel: 'ipProjectorFocusNode');

    _userProjectorFocusNode.addListener(_saveCredentialsProjector);
    _passwordProjectorFocusNode.addListener(_saveCredentialsProjector);
    _ipProjectorFocusNode.addListener(_saveIpProjector);

    _prefs.then((SharedPreferencesWithCache prefs) {
      _userProjector = prefs.getString('userProjector') ?? '';
      _userProjectorTextController.text = _userProjector;
      _passwordProjector = prefs.getString('passwordProjector') ?? '';
      _passwordProjectorTextController.text = _passwordProjector;
      _ipProjector = prefs.getString('ipProjector') ?? '';
      _ipProjectorTextController.text = _ipProjector;
    });
    super.initState();
  }

  @override
  void dispose() {
    _userProjectorFocusNode.removeListener(_saveCredentialsProjector);
    _passwordProjectorFocusNode.removeListener(_saveCredentialsProjector);
    _ipProjectorFocusNode.removeListener(_saveIpProjector);

    _userProjectorFocusNode.dispose();
    // _passwordProjectorFocusNode is already disposed somehow.
    // This has so.th. to do with the used PasswordBox widget.
    // _passwordProjectorFocusNode.dispose();
    _ipProjectorFocusNode.dispose();
    _userProjectorTextController.dispose();
    _passwordProjectorTextController.dispose();
    _ipProjectorTextController.dispose();
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
      ],
    );
  }
}

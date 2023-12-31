import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Einstellungen')),
      children: [
        LinkCard(
          leading: const Icon(
            ms_icons.FluentIcons.text_effects_sparkle_24_regular,
            size: 20,
          ),
          title: const Text('Personalisierung'),
          subtitle: const Text('Farbschema'),
          onPressed: () => context.go('/settings/appearance'),
        ),
        spacer,
        LinkCard(
          leading: const Icon(
            FluentIcons.screen,
            size: 20,
          ),
          title: const Text('Beamer'),
          subtitle: const Text('Anmeldedaten, IP-Adresse'),
          onPressed: () => context.go('/settings/projector'),
        ),
        spacer,
        LinkCard(
          leading: const Icon(
            ms_icons.FluentIcons.camera_dome_24_regular,
            size: 20,
          ),
          title: const Text('Kamera'),
          subtitle: const Text('Anmeldedaten, IP-Adresse, Positionen'),
          onPressed: () => context.go('/settings/camera'),
        ),
      ],
    );
  }
}

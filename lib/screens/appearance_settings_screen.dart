import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import '../widgets/list_card.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  final spacer = const SizedBox(height: 10.0);
  final biggerSpacer = const SizedBox(height: 40.0);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();

    final breadcrumbItems = <BreadcrumbItem<int>>[
      const BreadcrumbItem(label: Text('Einstellungen'), value: 0),
      const BreadcrumbItem(label: Text('Personalisierung'), value: 1),
    ];

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
      ],
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;

import '../../widgets/page.dart';
import '../../widgets/list_card.dart';
import '../models/camera.dart';

class CameraScreen extends StatefulWidget with PageMixin {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final spacer = const SizedBox(height: 10.0);
  final biggerSpacer = const SizedBox(height: 40.0);

  String? selectedPresetId;

  Widget emtpyListPlaceholder = LayoutBuilder(
    builder: ((context, constraints) {
      return Center(
        child: SizedBox(
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                ms_icons.FluentIcons.apps_list_20_regular,
                size: 70,
              ),
              Text(
                '(Es wurden noch keine Positionen konfiguriert)',
                style: FluentTheme.of(context).typography.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }),
  );

  Widget get presetList {
    var camera = Provider.of<Camera>(context, listen: false);
    var presets =
        camera.presets.where((preset) => preset.position != null).toList();

    return ListView.builder(
              shrinkWrap: true,
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                return ListTile.selectable(
                  leading: preset.icon,
                  title: Text(preset.name),
                  selected: selectedPresetId == preset.id,
                  onSelectionChange: (_) {
                    camera.gotoPresetId(preset.id);
                    setState(() => selectedPresetId = preset.id);
                  },
                );
              },
            );
  }

  @override
  Widget build(BuildContext context) {
    final camera = Provider.of<Camera>(context);
    var presets =
        camera.presets.where((preset) => preset.position != null).toList();

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Kamera')),
      children: [
        Text('Position ansteuern',
            style: FluentTheme.of(context).typography.subtitle),
        spacer,
        ListCard(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    FluentTheme.of(context).resources.surfaceStrokeColorDefault,
              ),
            ),
            child: presets.isEmpty ? emtpyListPlaceholder : presetList,
          ),
        ),
      ],
    );
  }
}

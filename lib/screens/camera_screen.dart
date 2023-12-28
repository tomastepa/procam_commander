import 'package:fluent_ui/fluent_ui.dart';
import 'package:procam_commander/widgets/list_card.dart';
import 'package:provider/provider.dart';

import '../../widgets/page.dart';
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

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<Camera>(context);
    var presets =
        cameraModel.presets.where((preset) => preset.position != null).toList();

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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                return ListTile.selectable(
                  leading: preset.icon,
                  title: Text(preset.name),
                  selected: selectedPresetId == preset.id,
                  onSelectionChange: (_) {
                    cameraModel.gotoPresetId(preset.id);
                    setState(() => selectedPresetId = preset.id);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

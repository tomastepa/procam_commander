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

  PresetId? selectedPresetId;

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<Camera>(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Kamera')),
      children: [
        Text('Presets', style: FluentTheme.of(context).typography.subtitle),
        spacer,
        ListCard(
          child: Container(
            // height: 400,
            // width: 350,
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    FluentTheme.of(context).resources.surfaceStrokeColorDefault,
              ),
            ),
            child: ListView.builder(
              // controller: firstController,
              shrinkWrap: true,
              itemCount: cameraModel.presets.length,
              itemBuilder: (context, index) {
                final preset = cameraModel.presets[index];
                return ListTile.selectable(
                  leading: preset.icon,
                  title: Text(preset.title),
                  selected: selectedPresetId == preset.id,
                  onSelectionChange: (v) {
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

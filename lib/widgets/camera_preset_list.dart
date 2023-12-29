import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;
import 'package:procam_commander/widgets/list_card.dart';
import 'package:provider/provider.dart';

import '../models/camera.dart';

class CameraPresetList extends StatefulWidget {
  const CameraPresetList({super.key});

  @override
  State<CameraPresetList> createState() => _CameraPresetListState();
}

class _CameraPresetListState extends State<CameraPresetList> {
  String? selectedPresetId;

  Widget emtpyListPlaceholder = LayoutBuilder(
    builder: ((context, constraints) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.6,
              child: const Icon(
                ms_icons.FluentIcons.apps_list_20_regular,
                size: 70,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '(Es wurden noch keine Positionen konfiguriert)',
              style: FluentTheme.of(context).typography.bodyLarge,
            ),
          ],
        ),
      );
    }),
  );

  Widget get presetCommandBar {
    return CommandBarCard(
      child: Row(children: [
        Expanded(
            child: CommandBar(
          overflowBehavior: CommandBarOverflowBehavior.scrolling,
          primaryItems: [
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "Neue Position anlegen",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.add),
                label: const Text('Neu'),
                onPressed: () => addPreset(),
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "Position bearbeiten",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.edit),
                label: const Text('Bearbeiten'),
                onPressed:
                    selectedPresetId == null ? null : () => changePreset(),
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "Position löschen",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.delete),
                label: const Text('Löschen'),
                onPressed: selectedPresetId == null ? null : removePreset,
              ),
            ),
          ],
        ))
      ]),
    );
  }

  Widget get presetList {
    var camera = Provider.of<Camera>(context, listen: false);

    return ListView.builder(
        itemBuilder: (ctx, index) {
          final preset = camera.presets[index];
          return ListTile.selectable(
            title: Text(preset.name),
            trailing: Text(
              preset.position != null ? preset.position.toString() : '',
              style: FluentTheme.of(context)
                  .typography
                  .body!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            key: ValueKey(preset.id), //wird hier eigentlich nicht benötigt
            leading: preset.icon,
            selected: selectedPresetId == preset.id,
            onPressed: () {
              selectedPresetId == preset.id
                  ? setState(() => selectedPresetId = null)
                  : setState(() => selectedPresetId = preset.id);
            },
          );
        },
        itemCount: camera.presets.length);
  }

  void addPreset() {
    selectedPresetId = null;
    showPresetDialog();
  }

  void changePreset() {
    showPresetDialog();
  }

  void removePreset() {
    var camera = Provider.of<Camera>(context, listen: false);

    try {
      camera.deletePreset(selectedPresetId!);
      selectedPresetId = null;
    } catch (e) {
      showErrorInfoBar(e.toString());
    }
  }

  void showErrorInfoBar(String message) {
    displayInfoBar(
      context,
      builder: (ctx, close) {
        return InfoBar(
          title: const Text('Fehler'),
          content: Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var camera = Provider.of<Camera>(context);

    return Column(
      children: [
        presetCommandBar,
        ListCard(
          child: SizedBox(
            height: 200,
            child: camera.presets.isEmpty ? emtpyListPlaceholder : presetList,
          ),
        ),
      ],
    );
  }

  void showPresetDialog() async {
    TextEditingController presetNameTextController = TextEditingController();

    var camera = Provider.of<Camera>(context, listen: false);
    Preset? preset;
    String presetName;
    int? presetPosition;

    if (selectedPresetId != null) {
      preset = camera.presets
          .firstWhere((element) => selectedPresetId == element.id);
      presetName = preset.name;
      presetPosition = preset.position;
    } else {
      presetName = '';
    }

    presetNameTextController.text = presetName;

    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        // title: const Text('Position bearbeiten'),
        content: Wrap(
          children: [
            Column(
              children: [
                InfoLabel(
                  label: 'Name der Kameraposition',
                  child: TextBox(
                    controller: presetNameTextController,
                    placeholder: 'Name',
                    expands: false,
                  ),
                ),
                const SizedBox(height: 10.0),
                InfoLabel(
                  label: 'Positionsnummer',
                  child: NumberBox(
                    mode: SpinButtonPlacementMode.inline,
                    value: presetPosition,
                    onChanged: (i) => presetPosition = i,
                    min: 1,
                    max: 255,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Speichern'),
            onPressed: () {
              Navigator.pop(context);
              if (preset == null) {
                camera.addPreset(
                    presetNameTextController.text,
                    const Icon(ms_icons.FluentIcons.diamond_24_regular),
                    presetPosition);
              } else {
                camera.changePreset(preset!.id, presetNameTextController.text,
                    preset.icon, presetPosition);
              }
            },
          ),
          Button(
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );

    presetNameTextController.dispose();
  }
}

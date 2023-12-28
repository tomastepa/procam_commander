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
                onPressed: () {},
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
                onPressed: selectedPresetId == null
                    ? null
                    : () {
                        showPresetDialog(context);
                      },
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
          final singlePresetItem = camera.presets[index];
          return ListTile.selectable(
            title: Text(singlePresetItem.name),
            key: ValueKey(
                singlePresetItem.id), //wird hier eigentlich nicht benötigt
            leading: singlePresetItem.icon,
            selected: selectedPresetId == singlePresetItem.id,
            onPressed: () {
              selectedPresetId == singlePresetItem.id
                  ? setState(() => selectedPresetId = null)
                  : setState(() => selectedPresetId = singlePresetItem.id);
            },
          );
        },
        itemCount: camera.presets.length);
  }

  void createPreset() {}

  void changePreset() {}

  void removePreset() {
    var camera = Provider.of<Camera>(context, listen: false);

    try {
      camera.deletePreset(selectedPresetId!);
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

  void showPresetDialog(BuildContext context, [String? presetId]) async {
    TextEditingController presetNameTextController = TextEditingController();

    var camera = Provider.of<Camera>(context, listen: false);

    var presetItem =
        camera.presets.firstWhere((element) => selectedPresetId == element.id);
    presetNameTextController.text = presetItem.name;

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
                    value: presetItem.position,
                    onChanged: (i) => presetItem.position = i,
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
              camera.changePreset(presetItem.id, presetNameTextController.text,
                  presetItem.icon, presetItem.position);
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

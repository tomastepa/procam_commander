import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../models/projector.dart';
import '../widgets/page.dart';
import '../widgets/list_card.dart';

class ProjectorScreen extends StatefulWidget {
  const ProjectorScreen({super.key});

  @override
  State<ProjectorScreen> createState() => _ProjectorScreenState();
}

class _ProjectorScreenState extends State<ProjectorScreen> with PageMixin {
  final spacer = const SizedBox(height: 10.0);
  final biggerSpacer = const SizedBox(height: 40.0);

  void onProjectorPowerChanged(bool isProjectorTurnedOn) async {
    final projectorModel = Provider.of<Projector>(context, listen: false);

    if (isProjectorTurnedOn) {
      projectorModel.turnOn();
    } else {
      await showDialog(
        context: context,
        builder: (ctx) {
          return ContentDialog(
            title: const Text('Beamer ausschalten'),
            content: const Text(
                'Soll der Beamer wirklich ausgeschaltet werden? Ein Neustart ist erst nach Abkühlen der Lampe wieder möglich und kann einige Minuten dauern.'),
            actions: [
              FilledButton(
                child: const Text('Ja'),
                onPressed: () {
                  Navigator.pop(ctx);
                  projectorModel.turnOff();
                },
              ),
              Button(
                child: const Text('Nein'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      );
    }
    // setState(() {
    //   b ? projectorModel.turnOn() : projectorModel.turnOff();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final projectorModel = Provider.of<Projector>(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Beamer')),
      children: [
        Text(
          'Aktionen',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        spacer,
        ListCard(
          child: Row(
            children: [
              const Icon(FluentIcons.power_button),
              const SizedBox(width: 10.0),
              const Text('Ein/Aus'),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ToggleSwitch(
                    checked: projectorModel.isPowerOn,
                    onChanged: onProjectorPowerChanged,
                    // onChanged: (b) => setState(() {
                    //   b ? projectorModel.turnOn() : projectorModel.turnOff();
                    // }),
                    leadingContent: true,
                    content: Text(projectorModel.isPowerOn ? 'An' : 'Aus'),
                  ),
                ),
              ),
            ],
          ),
        ),
        spacer,
        ListCard(
          child: Row(
            children: [
              const Icon(FluentIcons.device_off),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AV Mute',
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'Inhalte vorübergehend ein-/ausblenden (Bild "An" / "Aus")',
                    style: FluentTheme.of(context).typography.caption,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ToggleSwitch(
                    checked: projectorModel.isPowerOn
                        ? !projectorModel.isAvMuteOn
                        : false,
                    // disable ToggleSwitch for AV Mute if power is off
                    onChanged: !projectorModel.isPowerOn
                        ? null
                        : (b) => setState(() {
                              b
                                  ? projectorModel.avMuteOff()
                                  : projectorModel.avMuteOn();
                            }),
                    leadingContent: true,
                    content: Text(projectorModel.isPowerOn
                        ? !projectorModel.isAvMuteOn
                            ? 'An'
                            : 'Aus'
                        : projectorModel.isAvMuteOn
                            ? 'An'
                            : 'Aus'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

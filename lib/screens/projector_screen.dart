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

  // bool powerOn = false;
  bool avMuteOn = false;

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
                    onChanged: (b) => setState(() {
                      b ? projectorModel.turnOn() : projectorModel.turnOff();
                      // powerOn == false ? avMuteOn = false : null;
                    }),
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
                    'Inhalte vorübergehend ausblenden',
                    style: FluentTheme.of(context).typography.caption,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ToggleSwitch(
                    checked: avMuteOn,
                    // disable ToggleSwitch for AV Mute if power is off
                    onChanged: !projectorModel.isPowerOn
                        ? null
                        : (v) => setState(() => avMuteOn = v),
                    leadingContent: true,
                    content: Text(avMuteOn ? 'An' : 'Aus'),
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

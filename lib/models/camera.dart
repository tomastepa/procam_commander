import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;

class Camera extends ChangeNotifier {
  List<Preset> _presets = [];

  Camera() {
    fetchPresets();
  }

  void fetchPresets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? position = prefs.getInt('defaultCameraPosition');
    if (position != null && position > 0) {
      presets.add(
        Preset(
          'Default',
          position,
          const Icon(ms_icons.FluentIcons.home_24_regular),
        ),
      );
    }
    position = null;

    position = prefs.getInt('speakerCameraPosition');
    if (position != null && position > 0) {
      presets.add(
        Preset(
          'Redner',
          position,
          const Icon(ms_icons.FluentIcons.presenter_24_regular),
        ),
      );
    }
    position = null;

    position = prefs.getInt('readerCameraPosition');
    if (position != null && position > 0) {
      presets.add(
        Preset(
          'Leser',
          position,
          const Icon(ms_icons.FluentIcons.person_standing_16_regular),
        ),
      );
    }
    position = null;

    position = prefs.getInt('studentAssignmentCameraPosition');
    if (position != null && position > 0) {
      presets.add(
        Preset(
          'Studierendenaufgabe',
          position,
          const Icon(ms_icons.FluentIcons.people_24_regular),
        ),
      );
    }

    notifyListeners();
  }

  List<Preset> get presets => _presets;
}

class Preset {
  final String _title;
  final int _position;
  final Icon icon;

  Preset(
    this._title,
    this._position, [
    this.icon = const Icon(ms_icons.FluentIcons.frame_16_regular),
  ]);

  String get title => _title;

  int get position => _position;
}

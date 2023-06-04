import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;

import '../api/camera_api_client.dart';

class Camera extends ChangeNotifier {
  CameraApiClient apiClient = CameraApiClient.http();
  List<Preset> _presets = [];
  PresetId _currentPresetId = PresetId.none;

  Camera() {
    fetchPresets();
  }

  void onSettingsChanged() {
    apiClient = CameraApiClient.http();
  }

  void fetchPresets() async {
    List<Preset> presets = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? position = prefs.getInt('defaultCameraPosition');
    if (position != null && position > 0) {
      presets.add(
        Preset(
          PresetId.defaultCameraPosition,
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
          PresetId.speakerCameraPosition,
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
          PresetId.readerCameraPosition,
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
          PresetId.studentAssignmentCameraPosition,
          'Studierendenaufgabe',
          position,
          const Icon(ms_icons.FluentIcons.people_24_regular),
        ),
      );
    }

    _presets = presets;
    notifyListeners();
  }

  void gotoPresetId(PresetId presetId) {
    var preset = _presets.firstWhere((element) => element.id == presetId);
    apiClient.gotoPreset(preset.position);
    _currentPresetId = preset.id;
    notifyListeners();
  }

  List<Preset> get presets => _presets;

  PresetId get currentPresetId => _currentPresetId;
}

class Preset {
  final PresetId _id;
  final String _title;
  final int _position;
  final Icon icon;

  Preset(
    this._id,
    this._title,
    this._position, [
    this.icon = const Icon(ms_icons.FluentIcons.frame_16_regular),
  ]);

  PresetId get id => _id;

  String get title => _title;

  int get position => _position;
}

enum PresetId {
  none,
  defaultCameraPosition,
  speakerCameraPosition,
  readerCameraPosition,
  studentAssignmentCameraPosition
}

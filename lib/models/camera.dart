import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/camera_api_client.dart';

class Camera extends ChangeNotifier {
  CameraApiClient apiClient = CameraApiClient.http();
  List<Preset> _presets = [];
  String _currentPresetId = '';

  Camera() {
    fetchPresets();
  }

  void onSettingsChanged() {
    apiClient = CameraApiClient.http();
  }

  void fetchPresets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsonPresets = prefs.getString('cameraPresets');
    var presets = (jsonDecode(jsonPresets!) as List)
        .map((e) => Preset.fromJson(e))
        .toList();
    _presets = presets;
    notifyListeners();
  }

  void addPreset(String name, Icon? icon, int? position) {
    _presets.add(
      Preset(
        id: DateTime.now().toString(),
        name: name,
        icon: icon,
        position: position,
      ),
    );
    notifyListeners();
  }

  void deletePreset(String id) {
    var presetToRemoveIndex =
        _presets.indexWhere((element) => element.id == id);

    if (_presets[presetToRemoveIndex].isStandard == true) {
      throw Exception('Standardeinträge können nicht gelöscht werden.');
    }
    _presets.removeAt(presetToRemoveIndex);
    notifyListeners();
  }

  void changePreset(String id, String name, Icon? icon, int? position) {
    var presetToChange = _presets.firstWhere((element) => element.id == id);

    presetToChange.name = name;
    presetToChange.icon = icon;
    presetToChange.position = position;
    persistPresets();
    notifyListeners();
  }

  void persistPresets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsonPresets = jsonEncode(_presets);
    prefs.setString('cameraPresets', jsonPresets);
  }

  void gotoPresetId(String presetId) {
    var preset = _presets.firstWhere((element) => element.id == presetId);
    apiClient.gotoPreset(preset.position!);
    _currentPresetId = preset.id;
    notifyListeners();
  }

  List<Preset> get presets => _presets;

  String get currentPresetId => _currentPresetId;
}

class Preset {
  final String id;
  String name;
  Icon? icon;
  int? position;
  final bool isStandard;

  Preset({
    required this.id,
    required this.name,
    required this.icon,
    required this.position,
    this.isStandard = false,
  });

  factory Preset.fromJson(Map<String, dynamic> json) {
    Icon? icon;

    if (json['icon'] != null) {
      var codePoint = int.parse(json['icon']);
      icon = Icon(IconData(
        codePoint,
        fontFamily: 'FluentSystemIcons-Regular',
        fontPackage: 'fluentui_system_icons',
      ));
    }

    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: icon,
      position: json['position'] as int?,
      isStandard: json['isStandard'] as bool,
    );
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'icon': icon?.icon?.codePoint.toString(),
        'position': position,
        'isStandard': isStandard,
      };
}

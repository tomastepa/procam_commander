import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/camera_api_client.dart';

class Camera extends ChangeNotifier {
  CameraApiClient apiClient = CameraApiClient.http();
  List<Preset> _presets = [];
  String _currentPresetId = '';

  final List<Preset> _defaultPresets = [
    Preset(
      id: '1',
      name: 'Default',
      icon: const Icon(FluentIcons.home_24_regular),
      position: null,
      isStandard: true,
    ),
    Preset(
      id: '2',
      name: 'Redner',
      icon: const Icon(FluentIcons.presenter_24_regular),
      position: null,
      isStandard: true,
    ),
    Preset(
      id: '3',
      name: 'Leser',
      icon: const Icon(FluentIcons.person_standing_16_filled),
      position: null,
      isStandard: true,
    ),
    Preset(
      id: '4',
      name: 'Studierendenaufgabe',
      icon: const Icon(FluentIcons.people_24_regular),
      position: null,
      isStandard: true,
    ),
  ];

  Camera() {
    fetchPresets();
  }

  void initPresets() {
    _presets = _defaultPresets;
    persistPresets();
    notifyListeners();
  }

  void onSettingsChanged() {
    apiClient = CameraApiClient.http();
  }

  void fetchPresets() async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    var jsonPresets = prefs.getString('cameraPresets');
    if (jsonPresets == null) {
      if (kDebugMode) print('cameraPresets is null, initiating presets ...');
      initPresets();
      return;
    }
    var presets = (jsonDecode(jsonPresets) as List)
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
    persistPresets();
    notifyListeners();
  }

  void deletePreset(String id) {
    var presetToRemoveIndex =
        _presets.indexWhere((element) => element.id == id);

    if (_presets[presetToRemoveIndex].isStandard == true) {
      throw Exception('Standardeinträge können nicht gelöscht werden.');
    }
    _presets.removeAt(presetToRemoveIndex);
    persistPresets();
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
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

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

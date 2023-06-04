import 'package:fluent_ui/fluent_ui.dart';

import '../api/projector_api_client.dart';

class Projector extends ChangeNotifier {
  ProjectorApiClient _apiClient = ProjectorApiClient.http();
  bool _isPowerOn = false;
  bool _isAvMuteOn = false;

  onSettingsChanged() {
    _apiClient = ProjectorApiClient.http();
  }

  void turnOn() async {
    _apiClient.turnOn();
    _isPowerOn = true;
    notifyListeners();
  }

  void turnOff() async {
    _apiClient.turnOff();
    _isPowerOn = false;
    _isAvMuteOn = false;
    notifyListeners();
  }

  void avMuteOn() {
    _apiClient.avMuteOn();
    _isAvMuteOn = true;
    notifyListeners();
  }

  void avMuteOff() {
    _apiClient.avMuteOff();
    _isAvMuteOn = false;
    notifyListeners();
  }

  void fetchStatus() async {
    bool isPowerOn = await _apiClient.isPowerOn;
    bool isAvMuteOn = await _apiClient.isAvMuteOn;
    bool hasStatusChanged = false;

    if (isPowerOn != _isPowerOn) {
      _isPowerOn = isPowerOn;
      hasStatusChanged = true;
    }

    if (isAvMuteOn != _isAvMuteOn) {
      _isAvMuteOn = isAvMuteOn;
      hasStatusChanged = true;
    }

    if (hasStatusChanged) notifyListeners();
  }

  bool get isPowerOn => _isPowerOn;

  bool get isAvMuteOn => _isAvMuteOn;
}

import 'package:fluent_ui/fluent_ui.dart';

import '../api/projector_api_client.dart';

class Projector extends ChangeNotifier {
  ProjectorApiClient apiClient = ProjectorApiClient.http();
  bool _isPowerOn = false;
  bool _isAvMuteOn = false;

  void turnOn() async {
    apiClient.turnOn();
    _isPowerOn = true;
    notifyListeners();
  }

  void turnOff() async {
    apiClient.turnOff();
    _isPowerOn = false;
    notifyListeners();
  }

  void avMuteOn() {
    apiClient.avMuteOn();
    _isAvMuteOn = true;
    notifyListeners();
  }

  void avMuteOff() {
    apiClient.avMuteOff();
    _isAvMuteOn = false;
    notifyListeners();
  }

  void fetchStatus() async {
    bool isPowerOn = await apiClient.isPowerOn;
    bool isAvMuteOn = await apiClient.isAvMuteOn;
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

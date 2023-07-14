import 'package:fluent_ui/fluent_ui.dart';

import '../api/projector_api_client.dart';

class Projector extends ChangeNotifier {
  late ProjectorApiClient _apiClient = ProjectorApiClient.http();
  bool _isPowerOn = false;
  bool _isAvMuteOn = false;
  bool _hasError = false;
  String _errorMessage = '';

  onSettingsChanged() {
    _apiClient = ProjectorApiClient.http();
  }

  void turnOn() async {
    _apiClient.turnOn().then((_) {
      _isPowerOn = true;
      notifyListeners();
    }).catchError((error, _) {
      _hasError = true;
      _errorMessage = error.toString();
      notifyListeners();
    });
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

  void resetErrorState() {
    _hasError = false;
    _errorMessage = '';
  }

  bool get isPowerOn => _isPowerOn;

  bool get isAvMuteOn => _isAvMuteOn;

  String get errorMessage => _errorMessage;

  bool get hasError => _hasError;
}

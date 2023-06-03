import 'camera_http_client.dart';

abstract class CameraApiClient {
  factory CameraApiClient.http() => CameraHttpClient();

  // Future<List<int>> getPresets();
  void gotoPreset(int preset);
}

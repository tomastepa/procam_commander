abstract class CameraApiClient {
  // factory CameraApiClient.http() => CameraHttpClient();

  Future<List<int>> getPresets();
  void gotoPreset(int preset);
}

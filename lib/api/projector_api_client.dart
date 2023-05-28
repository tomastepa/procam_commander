import './projector_http_client.dart';

abstract class ProjectorApiClient {
  factory ProjectorApiClient.http() => ProjectorHttpClient();

  void turnOn();
  void turnOff();
  void avMuteOn();
  void avMuteOff();
  void setSourceHDMI1();
  Future<bool> get isPowerOn;
  Future<bool> get isAvMuteOn;
}

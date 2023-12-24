import './projector_http_client.dart';

abstract class ProjectorApiClient {
  factory ProjectorApiClient.http() => ProjectorHttpClient();

  Future<void> turnOn();
  Future<void> turnOff();
  Future<void> avMuteOn();
  Future<void> avMuteOff();
  void setSourceHDMI1();
  Future<bool> get isPowerOn;
  Future<bool> get isAvMuteOn;
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/camera_api_client.dart';
import 'api_exceptions.dart';

class CameraHttpClient implements CameraApiClient {
  late final String _ipAddress;
  late String _basicAuthToken;

  CameraHttpClient() {
    init();
  }

  void init() async {
    // read IP address from settings
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _basicAuthToken = getBasicAuthToken(prefs);
    _ipAddress = getIpAddress(prefs);
    print('IP: $_ipAddress');
  }

  String getIpAddress(SharedPreferences prefs) {
    String? ipAddress = prefs.getString('ipCamera');
    if (ipAddress == null) throw MissingParameterException();
    return ipAddress;
  }

  String getBasicAuthToken(SharedPreferences prefs) {
    String? username = prefs.getString('userCamera');
    String? password = prefs.getString('passwordCamera');
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }

  @override
  Future<void> gotoPreset(int preset) async {
    var url = Uri.http(
      _ipAddress,
      'cgi-bin/ptzctrl.cgi?ptzcmd&poscall&$preset',
    );
    print(url);
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

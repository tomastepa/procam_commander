import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    _basicAuthToken = getBasicAuthToken(prefs);
    _ipAddress = getIpAddress(prefs);
    if (kDebugMode) {
      print('IP: $_ipAddress');
    }
  }

  String getIpAddress(SharedPreferencesWithCache prefs) {
    String? ipAddress = prefs.getString('ipCamera');
    if (ipAddress == null || ipAddress.isEmpty) {
      throw MissingParameterException(
          'Zur Kamera wurde keine IP Adresse gefunden.');
    }
    return ipAddress;
  }

  String getBasicAuthToken(SharedPreferencesWithCache prefs) {
    String? username = prefs.getString('userCamera');
    String? password = prefs.getString('passwordCamera');
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }

  @override
  Future<void> gotoPreset(int preset) async {
    var url = Uri.http(
      _ipAddress,
      'cgi-bin/ptzctrl.cgi',
      {
        'ptzcmd': null,
        'poscall': null,
        '$preset': null,
      },
    );
    if (kDebugMode) {
      print(url);
    }
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}

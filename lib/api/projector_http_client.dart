import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './projector_api_client.dart';
import './api_exceptions.dart';

class ProjectorHttpClient implements ProjectorApiClient {
  String? _ipAddress;
  String? _basicAuthToken;
  static const String _emptyAuthToken = 'Basic bnVsbDpudWxs';

  ProjectorHttpClient() {
    init();
  }

  init() async {
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

  String? getIpAddress(SharedPreferencesWithCache prefs) {
    String? ipAddress = prefs.getString('ipProjector');
    // if (ipAddress == null || ipAddress.isEmpty) {
    //   throw MissingParameterException(
    //       'Zum Beamer wurde keine IP Adresse gefunden.');
    // }
    return ipAddress;
  }

  String? getBasicAuthToken(SharedPreferencesWithCache prefs) {
    String? username = prefs.getString('userProjector');
    String? password = prefs.getString('passwordProjector');
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }

  @override
  Future<void> turnOn() async {
    try {
      validateParams();
      var url = Uri.http(_ipAddress!, 'cgi-bin/power_on.cgi');
      var response = await http.get(
        url,
        headers: {'authorization': _basicAuthToken as String},
      );
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> turnOff() async {
    try {
      validateParams();
      var url = Uri.http(_ipAddress!, 'cgi-bin/power_off.cgi');
      var response = await http.get(
        url,
        headers: {'authorization': _basicAuthToken as String},
      );
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> avMuteOn() async {
    try {
      validateParams();
      var url = Uri.http(_ipAddress!, 'cgi-bin/proj_ctl.cgi',
          {'key': 'shutter_on', 'lang': 'e'});
      if (kDebugMode) {
        print(url);
      }
      var response = await http.get(
        url,
        headers: {'authorization': _basicAuthToken as String},
      );
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> avMuteOff() async {
    try {
      validateParams();
      var url = Uri.http(_ipAddress!, 'cgi-bin/proj_ctl.cgi',
          {'key': 'shutter_off', 'lang': 'e'});
      var response = await http.get(
        url,
        headers: {'authorization': _basicAuthToken as String},
      );
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setSourceHDMI1() async {
    var url = Uri.http(_ipAddress!, 'cgi-bin/proj_ctl.cgi',
        {'key': 'hdmi', 'lang': 'e', 'osd': 'on'});
    var response = await http.post(
      url,
      headers: {'authorization': _basicAuthToken as String},
    );
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Future<bool> get isPowerOn async {
    try {
      var statusPage = await fetchStatusPage();
      if (statusPage.length < 2700) {
        throw Exception('Failed to load projector\'s status page');
      }

      // if the font color is grey (#999999), power is off
      if (statusPage.contains('<font color="#999999"><b>ON</b>')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> get isAvMuteOn async {
    try {
      var statusPage = await fetchStatusPage();
      if (statusPage.length < 2700) {
        throw Exception('Failed to load projector\'s status page');
      }

      // if the font color is grey (#999999), AV Mute is off
      if (statusPage
          .contains('<font color="#999999">&nbsp;&nbsp;<b>AV MUTE</b>')) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchStatusPage() async {
    if (_ipAddress == null) {
      throw MissingParameterException(
          'Zum Beamer wurde keine IP Adresse gefunden.');
    }
    if (_basicAuthToken == null) {
      throw MissingParameterException(
          'Zum Beamer wurden keine Anmeldedaten gefunden.');
    }
    var url =
        Uri.http(_ipAddress!, 'cgi-bin/projector_status.cgi', {'lang': 'e'});
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken as String},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to load projector\'s status page');
  }

  void validateParams() {
    if (_ipAddress == null) {
      throw MissingParameterException(
          'Zum Beamer wurde keine IP Adresse gefunden.');
    }
    if (_basicAuthToken == null || _basicAuthToken == _emptyAuthToken) {
      throw MissingParameterException(
          'Zum Beamer wurden keine Anmeldedaten gefunden.');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './projector_api_client.dart';
import './api_exceptions.dart';

class ProjectorHttpClient implements ProjectorApiClient {
  late final String _ipAddress;
  late String _basicAuthToken;

  ProjectorHttpClient() {
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
    String? ipAddress = prefs.getString('ipProjector');
    if (ipAddress == null) throw MissingParameterException();
    return ipAddress;
  }

  String getBasicAuthToken(SharedPreferences prefs) {
    String? username = prefs.getString('userProjector');
    String? password = prefs.getString('passwordProjector');
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }

  @override
  void turnOn() async {
    var url = Uri.http(_ipAddress, 'cgi-bin/power_on.cgi');
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void turnOff() async {
    var url = Uri.http(_ipAddress, 'cgi-bin/power_off.cgi');
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void avMuteOn() async {
    var url = Uri.http(_ipAddress, 'cgi-bin/proj_ctl.cgi',
        {'key': 'shutter_on', 'lang': 'e'});
    print(url);
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void avMuteOff() async {
    var url = Uri.http(_ipAddress, 'cgi-bin/proj_ctl.cgi',
        {'key': 'shutter_off', 'lang': 'e'});
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void setSourceHDMI1() async {
    var url = Uri.http(_ipAddress, 'cgi-bin/proj_ctl.cgi',
        {'key': 'hdmi', 'lang': 'e', 'osd': 'on'});
    var response = await http.post(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Future<bool> get isPowerOn async {
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
  }

  @override
  Future<bool> get isAvMuteOn async {
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
  }

  Future<String> fetchStatusPage() async {
    var url =
        Uri.http(_ipAddress, 'cgi-bin/projector_status.cgi', {'lang': 'e'});
    var response = await http.get(
      url,
      headers: {'authorization': _basicAuthToken},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to load projector\'s status page');
  }
}

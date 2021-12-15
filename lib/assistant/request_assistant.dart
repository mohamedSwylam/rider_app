import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(url) async {
    http.Response response =await http.get(url);
    try {
      if (response.statusCode == 200) {
        String jasonData = response.body;
        var decodeData = jsonDecode(jasonData);
        return decodeData;
      } else {
        return 'failed';
      }
    } catch (exp) {
      return 'failed';
    }
  }
}

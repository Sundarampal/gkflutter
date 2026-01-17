import 'dart:convert';
import 'package:http/http.dart' as http;

class Utilities {
  static Future<Map<String, dynamic>> downloadJson(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("JSON load failed");
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Utilities {
  static Future<dynamic> downloadJson(String url) async {
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) return json.decode(resp.body);
    } catch (_) {}
    return null;
  }
}
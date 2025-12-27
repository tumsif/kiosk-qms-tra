import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiosk_qms/config.dart';
import 'package:logger/logger.dart';
import '../models/service.dart';

Future<List<Service>> fetchServices() async {
  final baseUrl = Config.baseUrl;
  final response = await http.get(Uri.parse('$baseUrl/v1/services/'));
  var log = Logger();

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Service.fromJson(json)).toList();
  } else {
    log.e("Failed to load services");
    throw Exception('Failed to load services');
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class QueueApi {
  static const String baseUrl = "http://localhost:9000";

  static Future<Map<String, dynamic>> addToQueue({
    required String customerName,
    required String phoneNumber,
    required String tinNumber,
    required String serviceBlockId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/v1/queues/request"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_name": customerName,
        "customer_phone_number": phoneNumber,
        "customer_tin_number": tinNumber,
        "service_block_id": serviceBlockId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create queue");
    }
  }
}

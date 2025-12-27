import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiosk_qms/config.dart';

class QueueApi {
  static const String baseUrl = Config.baseUrl;

  static Future<Map<String, dynamic>> addToQueue({
    String? customerName,
    String? phoneNumber,
    String? tinNumber,
    required String serviceBlockId,
  }) async {
    final Map<String, dynamic> body = {
      "service_block_id": serviceBlockId,
    };

    if (customerName != null) body["customer_name"] = customerName;
    if (phoneNumber != null) body["customer_phone_number"] = phoneNumber;
    if (tinNumber != null) body["customer_tin_number"] = tinNumber;

    final response = await http.post(
      Uri.parse("$baseUrl/v1/queues/request"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create queue");
    }
  }
}

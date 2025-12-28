import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiosk_qms/services/printer_service.dart';

class TicketPage extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const TicketPage({super.key, required this.ticket});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final PrinterService _printerService = PrinterService();

  @override
  void initState() {
    super.initState();
    _startPrinting();
  }

  Future<void> _startPrinting() async {
    String queueNum = widget.ticket["queue_number"];
    String? customerName = widget.ticket["customer_name"];
    String? customerPhone = widget.ticket["customer_phone_number"];
    String? customerTinNumber = widget.ticket["customer_tin_number"];
    String? serviceName = widget.ticket["service_name"];
    String? serviceBlockName = widget.ticket["service_block_name"];

    bool success = await _printerService.printReceipt(
      queueNum,
      additionalLines: [
        if (customerName != null && customerName.isNotEmpty)
          'Customer: $customerName',
        if (customerPhone != null && customerPhone.isNotEmpty)
          'Phone: $customerPhone',
        if (customerTinNumber != null && customerTinNumber.isNotEmpty)
          'TIN: $customerTinNumber',
        '',
        'Please wait for your number',
        'to be called',
        '',
        'Tafadhali subiri',
        'namba yako kuitwa'
        '',
        '',
        'Service: $serviceName',
        'Block: $serviceBlockName',
        '',
        'Date: ${DateTime.now().toString().split('.')[0]}',
      ],
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ticket printed: $queueNum')));
      Timer(Duration(seconds: 5), () {
        Navigator.popUntil(
          context,
          (r) => r.isFirst,
        ); // Return to the first page
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print failed. Check printer connection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdTime = DateTime.tryParse(widget.ticket['created_time'] ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.yellow.shade600, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HEADER
              Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/tra_logo.jpg'),
                    height: 68,
                    width: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "QUEUE TICKET",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // QUEUE NUMBER
              Column(
                children: [
                  const Text(
                    "QUEUE NUMBER",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.ticket['queue_number'],
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFC107),
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // CUSTOMER DETAILS
              if (widget.ticket['customer_name'] != null) _infoRow("Customer", widget.ticket['customer_name']),
              if (widget.ticket['customer_phone_number'] != null) _infoRow("Phone", widget.ticket['customer_phone_number']),
              if (widget.ticket['customer_tin_number'] != null) _infoRow("customer_tin_number", widget.ticket['customer_tin_number']),
              _infoRow("Service", widget.ticket['service_name']),
              _infoRow(
                "Block",
                widget.ticket['service_block_name'] == "-" ||
                        widget.ticket['service_block_name'].toString().isEmpty
                    ? widget.ticket['service_name']
                    : widget.ticket['service_block_name'],
              ),

              const SizedBox(height: 16),

              // DATE & WAIT TIME
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      "Estimated wait: ${widget.ticket['estimated_wait']} mins",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (createdTime != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('dd MMM yyyy • HH:mm').format(createdTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // DONE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (r) => r.isFirst);
                  },
                  child: const Text(
                    "DONE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SMALL HELPER FOR CONSISTENT ROWS
  Widget _infoRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
  }
}

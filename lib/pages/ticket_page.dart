import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketPage extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final createdTime =
        DateTime.tryParse(ticket['created_time'] ?? '');

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
                color: Colors.black.withOpacity(0.15),
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
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 48,
                    color: Colors.yellow.shade700,
                  ),
                  const SizedBox(height: 8),
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
                    ticket['queue_number'],
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
              _infoRow("Customer", ticket['customer_name']),
              _infoRow("Phone", ticket['customer_phone_number']),
              _infoRow("Service", ticket['service_name']),
              _infoRow(
                "Block",
                ticket['service_block_name'] == "-" ||
                        ticket['service_block_name'].toString().isEmpty
                    ? "-"
                    : ticket['service_block_name'],
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
                      "Estimated wait: ${ticket['estimated_wait']} mins",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (createdTime != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('dd MMM yyyy • HH:mm')
                            .format(createdTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ]
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

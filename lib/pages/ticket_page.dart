import 'package:flutter/material.dart';

class TicketPage extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "YOUR QUEUE NUMBER",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  ticket['queue_number'],
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 20),
                Text("Service: ${ticket['service_name']}"),
                Text("Block: ${ticket['service_block_name']}"),
                const SizedBox(height: 20),
                Text("Estimated wait: ${ticket['estimated_wait']} mins"),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (r) => r.isFirst);
                  },
                  child: const Text("DONE"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

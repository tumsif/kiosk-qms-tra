import 'package:flutter/material.dart';
import 'package:kiosk_qms/models/service.dart';
import 'package:kiosk_qms/pages/ticket_page.dart';
import 'package:kiosk_qms/services/queue_api.dart';

class ServiceFormPage extends StatefulWidget {
  final Service service;

  const ServiceFormPage({super.key, required this.service});

  @override
  _ServiceFormPageState createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _serviceController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedBlockId;

  @override
  void initState() {
    super.initState();
    _serviceController.text = widget.service.name; // ✅ auto-fill service
  }

  @override
  Widget build(BuildContext context) {
    final hasBlocks = widget.service.blocks.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // SERVICE (READ ONLY)
              TextFormField(
                controller: _serviceController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Service",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // SHOW BLOCKS ONLY IF THEY EXIST
              if (hasBlocks)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Block",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.service.blocks.map((block) {
                    return DropdownMenuItem(
                      value: block.id,
                      child: Text(block.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedBlockId = value);
                  },
                  validator: (value) {
                    if (hasBlocks && value == null) {
                      return "Please select a block";
                    }
                    return null;
                  },
                ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

             const SizedBox(height: 30),

              Row(
                children: [
                  // RESET BUTTON
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {
                        setState(() {
                          _nameController.clear();
                          _phoneController.clear();
                          _selectedBlockId = null;
                        });
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // SUBMIT BUTTON
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          try {
                            final ticket = await QueueApi.addToQueue(
                              customerName: _nameController.text,
                              phoneNumber: _phoneController.text,
                              tinNumber: "", // optional
                              serviceBlockId: _selectedBlockId!,
                            );

                            // AFTER SUCCESS → SHOW TICKET
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketPage(ticket: ticket),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },

                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

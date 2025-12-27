import 'package:flutter/material.dart';
import 'package:kiosk_qms/models/service.dart';
import 'package:kiosk_qms/pages/ticket_page.dart';
import 'package:kiosk_qms/services/queue_api.dart';

class ServiceFormPage extends StatefulWidget {
  final Service service;
  final Block block;

  const ServiceFormPage({
    super.key,
    required this.service,
    required this.block,
  });

  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tinNumberController = TextEditingController();

  String _language = 'EN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            // ================= TOP BAR =================
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Row(
                children: [
                  // BACK BUTTON
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFC107)),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // LOGO + TITLE
                  Expanded(
                    child: LayoutBuilder(
                        builder: (context, constraint) {
                          if (constraint.maxWidth < 760) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                  image: AssetImage('assets/images/tra_logo.jpg'),
                                  height: 48,
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                  image: AssetImage('assets/images/tra_logo.jpg'),
                                  height: 48,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'TRA SELF SERVICE KIOSK',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ],
                            );
                          }
                        })
                  ),

                  // LANGUAGE SWITCH
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButton<String>(
                      value: _language,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'EN', child: Text('EN')),
                        DropdownMenuItem(value: 'SW', child: Text('SW')),
                      ],
                      onChanged: (value) {
                        setState(() => _language = value!);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= FORM CARD =================
            Expanded(
              child: Center(
                child: Container(
                  width: 520,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // HEADER
                        Text(
                          _language == 'EN'
                              ? 'Customer Information'
                              : 'Taarifa za Mteja',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // SERVICE + BLOCK INFO
                        Row(
                          children: [
                            _infoChip('Service', widget.service.name),
                            const SizedBox(width: 12),
                            _infoChip(
                              'Block',
                              widget.block.name,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // FULL NAME
                        _inputField(
                          controller: _nameController,
                          label: _language == 'EN'
                              ? 'Full Name'
                              : 'Jina Kamili',
                          icon: Icons.person_outline,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),

                        const SizedBox(height: 20),

                        // PHONE NUMBER
                        _inputField(
                          controller: _phoneController,
                          label: _language == 'EN'
                              ? 'Phone Number'
                              : 'Namba ya Simu',
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),

                        const SizedBox(height: 32),

                        // TIN NUMBER
                        _inputField(
                          controller: _tinNumberController,
                          label: _language == 'EN'
                              ? 'TIN number'
                              : 'Namba ya TIN',
                          icon: Icons.badge,
                          keyboard: TextInputType.number,
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                        ),

                        const SizedBox(height: 32),

                        // ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  _nameController.clear();
                                  _phoneController.clear();
                                },
                                child: Text(
                                  _language == 'EN' ? 'Reset' : 'Futa',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFFFC107),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _submit,
                                child: Text(
                                  _language == 'EN' ? 'Submit' : 'Wasilisha',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ================= FOOTER =================
            Container(
              height: 56,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Text(
                _language == 'EN'
                    ? 'Fill details and submit to get a ticket'
                    : 'Jaza taarifa na uwasilishe kupata tiketi',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _infoChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4D6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final ticket = await QueueApi.addToQueue(
        customerName: _nameController.text,
        phoneNumber: _phoneController.text,
        tinNumber: _tinNumberController.text,
        serviceBlockId: widget.block.id,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketPage(ticket: ticket),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

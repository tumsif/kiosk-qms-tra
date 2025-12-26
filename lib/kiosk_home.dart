import 'package:flutter/material.dart';
import 'package:kiosk_qms/widgets/services_grid.dart';

class KioskHome extends StatefulWidget {
  const KioskHome({super.key});

  @override
  State<KioskHome> createState() => _KioskHomeState();
}

class _KioskHomeState extends State<KioskHome> {
  String _language = 'ENG';

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
                  // LOGO
                  Row(
                    children: const [
                      Image(image:AssetImage('assets/images/tra_logo.jpg'),
                      height: 58, width: 58),

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
                  ),

                  const Spacer(),

                  // LANGUAGE SELECTOR
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _language,
                        items: const [
                          DropdownMenuItem(
                              value: 'ENG', child: Text('ENG')),
                          DropdownMenuItem(
                              value: 'SWA', child: Text('SWA')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _language = value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= TITLE =================
            Text(
              _language == 'ENG'
                  ? 'Please select a service'
                  : 'Tafadhali chagua huduma',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 32),

            // ================= SERVICES GRID =================
            const Expanded(
              child: ServicesGrid(),
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
                _language == 'ENG'
                    ? 'Touch a service to continue'
                    : 'Gusa huduma kuendelea',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kiosk_qms/widgets/services_grid.dart';



class KioskHome extends StatelessWidget {
  const KioskHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // ===== TOP BAR =====
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF1F2937), // dark professional header
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "SELF SERVICE KIOSK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),

            Text(
              "Please select a service".toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),


            const SizedBox(height: 40),

            // ===== SERVICES GRID =====

                  Expanded(
                      child: ServicesGrid(),
                  ),


            // ===== FOOTER =====
            Container(
              height: 60,
              color: const Color(0xFFF3F4F6),
              alignment: Alignment.center,
              child: const Text(
                "Touch a service to continue",
                style: TextStyle(
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

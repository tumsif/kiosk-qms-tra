import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // light gray like bg-gray-100

      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "TRA Available Services",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // SERVICES GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.2,
                children: const [
                  ServiceCard(
                    title: "TIN Registration",
                    description: "Register or update your Taxpayer Identification Number",
                    icon: Icons.badge_outlined,
                  ),
                  ServiceCard(
                    title: "EFD Services",
                    description: "Electronic Fiscal Device registration and support",
                    icon: Icons.print_outlined,
                  ),
                  ServiceCard(
                    title: "Tax Clearance",
                    description: "Request and print tax clearance certificate",
                    icon: Icons.description_outlined,
                  ),
                  ServiceCard(
                    title: "Payments",
                    description: "Make tax and government payments securely",
                    icon: Icons.payments_outlined,
                  ),
                ],
              ),
            ),

            // FOOTER
            const SizedBox(height: 10),
            const Text(
              "© 2025 Tanzania Revenue Authority • Self Service Kiosk",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6, // ✅ STATIC BUTTON SHADOW
      shadowColor: Colors.black.withOpacity(0.25),
      borderRadius: BorderRadius.circular(20),

      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigate to service page
        },

        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ICON
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.yellow.shade700,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.yellow.shade700,
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

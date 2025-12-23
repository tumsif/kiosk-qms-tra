import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 600;
    final isMedium = screenWidth >= 600 && screenWidth < 900;
    final isLarge = screenWidth >= 900;
    
    final horizontalPadding = isSmall ? 16.0 : (isMedium ? 20.0 : 24.0);
    final gridColumns = isSmall ? 1 : (isMedium ? 2 : 3);
    final gridSpacing = isSmall ? 16.0 : 24.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      
      appBar: AppBar(
        elevation: 0,
        actionsPadding: const EdgeInsets.all(4),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "TRA Available Services",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: isSmall ? 18 : 20, // Responsive title size
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(horizontalPadding), // Responsive padding
        child: Column(
          children: [
            SizedBox(height: isSmall ? 8 : 10), // Responsive spacing

            // SERVICES GRID
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double aspectRatio;
                  if (isSmall) {
                    aspectRatio = 1.8; // Wider cards on mobile
                  } else if (isMedium) {
                    aspectRatio = 1.5;
                  } else {
                    aspectRatio = 1.4;
                  }
                  
                  return GridView.count(
                    crossAxisCount: gridColumns, // Responsive columns
                    crossAxisSpacing: gridSpacing,
                    mainAxisSpacing: gridSpacing,
                    childAspectRatio: aspectRatio,
                    children: [
                      ServiceCard(
                        title: "TIN Registration",
                        description: "Register or update your Taxpayer Identification Number",
                        icon: Icons.badge_outlined,
                        isSmallScreen: isSmall, // Pass screen size info
                      ),
                      ServiceCard(
                        title: "EFD Services",
                        description: "Electronic Fiscal Device registration and support",
                        icon: Icons.print_outlined,
                        isSmallScreen: isSmall,
                      ),
                      ServiceCard(
                        title: "Tax Clearance",
                        description: "Request and print tax clearance certificate",
                        icon: Icons.description_outlined,
                        isSmallScreen: isSmall,
                      ),
                      ServiceCard(
                        title: "Payments",
                        description: "Make tax and government payments securely",
                        icon: Icons.payments_outlined,
                        isSmallScreen: isSmall,
                      ),
                    ],
                  );
                },
              ),
            ),

            // FOOTER
            SizedBox(height: isSmall ? 8 : 10), // Responsive spacing
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "© 2025 Tanzania Revenue Authority • Self Service Kiosk",
                textAlign: TextAlign.center, // Center text on small screens
                style: TextStyle(
                  fontSize: isSmall ? 11 : 13, // Responsive font size
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

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSmallScreen; // Added screen size parameter

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = isSmallScreen ? 16.0 : 24.0;
    final iconSize = isSmallScreen ? 48.0 : 56.0;
    final iconInnerSize = isSmallScreen ? 26.0 : 30.0;
    final titleSize = isSmallScreen ? 16.0 : 18.0;
    final descriptionSize = isSmallScreen ? 13.0 : 14.0;
    final borderRadius = isSmallScreen ? 16.0 : 20.0;
    
    return Material(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.25),
      borderRadius: BorderRadius.circular(borderRadius),

      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          // Navigate to service page
        },

        child: Padding(
          padding: EdgeInsets.all(cardPadding), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Container(
                height: iconSize, // Responsive icon container
                width: iconSize,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
                ),
                child: Icon(
                  icon,
                  size: iconInnerSize, // Responsive icon size
                  color: Colors.yellow.shade700,
                ),
              ),

              SizedBox(height: isSmallScreen ? 12 : 20), // Responsive spacing

              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize, // Responsive title
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, // Prevent overflow
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isSmallScreen ? 6 : 10), // Responsive spacing

              Text(
                description,
                style: TextStyle(
                  fontSize: descriptionSize, // Responsive description
                  color: Colors.black54,
                  height: 1.4,
                ),
                maxLines: 3, // Prevent overflow
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              Row(
                children: [
                  Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 13 : 14, // Responsive button text
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: isSmallScreen ? 16 : 18, // Responsive arrow
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

import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/services_api.dart';
import '../service_button.dart';
 
 
class ServicesGrid extends StatefulWidget {
  const ServicesGrid({super.key});

  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid> {
  late Future<List<Service>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Service>>(
      future: _servicesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } 
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No services available'));
        } 
        else {
          final services = snapshot.data!;
          return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300, // 👈 button max width
                mainAxisSpacing: 28,
                crossAxisSpacing: 28,
                childAspectRatio: 1.1,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceButton(
                  icon: _getIcon(service.name),
                  service: service,
                );
              },
            );
            
          
        }
      },
    );
  }

  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'tin': return Icons.badge;
      case 'efd': return Icons.receipt_long;
      case 'queue': return Icons.people;
      case 'payments': return Icons.payment;
      case 'forms': return Icons.description;
      case 'support': return Icons.help_outline;
      case 'browser': return Icons.language;
      case 'info': return Icons.info_outline;
      default: return Icons.help_outline;
    }
  }
}


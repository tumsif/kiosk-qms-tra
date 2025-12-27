import 'package:flutter/material.dart';
import 'package:kiosk_qms/models/service.dart';
import 'package:kiosk_qms/services/services_api.dart';
import 'service_button.dart';

class ServicesGrid extends StatefulWidget {
  const ServicesGrid({super.key});

  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid>
    with SingleTickerProviderStateMixin {
  late Future<List<Service>> _servicesFuture;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();

    _servicesFuture = fetchServices();

    //  Controller MUST be initialized first
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Service>>(
      future: _servicesFuture,
      builder: (context, snapshot) {
        //  LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(strokeWidth: 3),
                SizedBox(height: 16),
                Text('Loading services...',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          );
        }

        //  ERROR
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Failed to load services',
              style: TextStyle(color: Colors.redAccent, fontSize: 18),
            ),
          );
        }

        //  EMPTY
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No services available',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        final services = snapshot.data!;

        // ✅ Start animation only once
        if (!_animationStarted) {
          _controller.forward();
          _animationStarted = true;
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320,
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                childAspectRatio: 1.05,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceButton(
                  // icon: _getIcon(service.name),
                  service: service,
                );
              },
            ),
          ),
        );
      },
    );
  }

  
 }
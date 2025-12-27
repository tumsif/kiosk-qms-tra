import 'package:flutter/material.dart';
import 'package:kiosk_qms/pages/service_form.dart';
import 'package:kiosk_qms/pages/block_grid_page.dart';
import 'package:kiosk_qms/models/service.dart';

import 'package:kiosk_qms/services/queue_api.dart';

import '../pages/ticket_page.dart';

class ServiceButton extends StatefulWidget {
  // final IconData icon;
  final Service service;

  const ServiceButton({
    super.key,
    // required this.icon,
    required this.service,
  });

  @override
  State<ServiceButton> createState() => _ServiceButtonState();
}

class _ServiceButtonState extends State<ServiceButton> {
  bool _pressed = false;

  void _handleTap(BuildContext context) {
    // All services must have a default block, this makes the length to be one if the service has no other blocks.
    if (widget.service.blocks.length > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlockGridPage(service: widget.service),
        ),
      );
    } else if (widget.service.blocks.length == 1) {
      if (widget.service.requireUserData) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceFormPage(service: widget.service, block: widget.service.blocks[0],),
          ),
        );
      } else {
        _requestTicket(widget.service.blocks[0]);
      }
    } else {
      throw Exception("This service has no block");
    }
  }

  /// A special method to submit a request to get a ticket with no actual data
  Future<void> _requestTicket(Block block) async {
    try {
      final ticket = await QueueApi.addToQueue(
        customerName: null,
        phoneNumber: null,
        tinNumber: null,
        serviceBlockId: block.id,
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

  @override
  Widget build(BuildContext context) {
    bool hovered = false; // hover state

    return MouseRegion(
      cursor: SystemMouseCursors.click, // pointer cursor
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => _handleTap(context),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : (hovered ? 1.03 : 1.0), // shrink on press, grow on hover
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFC107), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(),
                  blurRadius: _pressed ? 6 : 14,
                  offset: Offset(0, _pressed ? 3 : 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ICON TILE
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child:
                        widget.service.iconUrl != null &&
                            widget.service.iconUrl!.isNotEmpty
                        ? Image.network(
                            widget.service.iconUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.help_outline,
                              color: Color(0xFFFFC107),
                            ),
                          )
                        : const Icon(
                            Icons.help_outline,
                            color: Color(0xFFFFC107),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // SERVICE NAME
                Text(
                  widget.service.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

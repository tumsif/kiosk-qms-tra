import 'package:flutter/material.dart';
import 'package:kiosk_qms/pages/service_form.dart';
import 'package:kiosk_qms/pages/block_grid_page.dart';
import 'package:kiosk_qms/models/service.dart';

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
    if (widget.service.blocks.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlockGridPage(service: widget.service),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceFormPage(service: widget.service),
        ),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  bool _hovered = false; // hover state

  return MouseRegion(
    cursor: SystemMouseCursors.click, // pointer cursor
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => _handleTap(context),
      child: AnimatedScale(
        scale: _pressed
            ? 0.97
            : _hovered
                ? 1.03
                : 1.0, // shrink on press, grow on hover
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFFFC107),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_pressed ? 0.08 : 0.15),
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
                    child: widget.service.iconUrl != null && widget.service.iconUrl!.isNotEmpty
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
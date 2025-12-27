import 'package:flutter/material.dart';
import 'package:kiosk_qms/pages/printer_setup_page.dart';
import 'package:kiosk_qms/providers/language_provider.dart';
import 'package:kiosk_qms/services/printer_service.dart';
import 'package:kiosk_qms/widgets/services_grid.dart';
import 'package:provider/provider.dart';

class KioskHome extends StatefulWidget {
  const KioskHome({super.key});

  @override
  State<KioskHome> createState() => _KioskHomeState();
}

class _KioskHomeState extends State<KioskHome> {
  final PrinterService _printerService = PrinterService();
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializePrinter();
  }

  Future<void> _initializePrinter() async {
    bool success = await _printerService.initialize();

    setState(() {
      _isInitializing = false;
    });

    if (!success && mounted) {
      // No printer configured, show setup
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrinterSetupScreen()),
      );

      if (result == true) {
        // Printer configured successfully
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing printer...'),
            ],
          ),
        ),
      );
    }
    return Consumer<LanguageProvider>(builder: (context, languageState, child) {
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
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 500) {
                      return Row(
                        children: [
                          Image(
                            image: AssetImage('assets/images/tra_logo.jpg'),
                            height: 58,
                            width: 58,
                          ),
                          const Spacer(),
                          // LANGUAGE SELECTOR
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: languageState.language == Language.english ? 'ENG' : 'SWA',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'ENG',
                                    child: Text('ENG'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'SWA',
                                    child: Text('SWA'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    languageState.setLanguage(value == 'ENG' ? Language.english : Language.swahili);
                                  }
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(
                              _printerService.isConnected
                                  ? Icons.print
                                  : Icons.print_disabled,
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrinterSetupScreen(),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage(
                                    'assets/images/tra_logo.jpg'),
                                height: 58,
                                width: 58,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'SELF SERVICE KIOSK',
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: languageState.language == Language.english ? 'ENG' : 'SWA',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'ENG',
                                    child: Text('ENG'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'SWA',
                                    child: Text('SWA'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    languageState.setLanguage(value == 'ENG' ? Language.english : Language.swahili);
                                  }
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(
                              _printerService.isConnected
                                  ? Icons.print
                                  : Icons.print_disabled,
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrinterSetupScreen(),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ================= TITLE =================
              Text(
                languageState.language == Language.english
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
              const Expanded(child: ServicesGrid()),

              // ================= FOOTER =================
              Container(
                height: 56,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: Text(
                  languageState.language == Language.english
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
    });
  }
}

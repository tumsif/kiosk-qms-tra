import 'package:flutter/material.dart';
import 'package:kiosk_qms/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'kiosk_home.dart';

void main() {
  runApp(const KioskApp());
}

class KioskApp extends StatelessWidget {
  const KioskApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Service Kiosk',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFFC107),
          ),
        ),
        home: const KioskHome(),
      ),
    );
  }
}

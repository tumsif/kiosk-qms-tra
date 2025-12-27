import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:kiosk_qms/services/printer_service.dart';
import 'package:kiosk_qms/services/bluetooth_permission_handler.dart';

class PrinterSetupScreen extends StatefulWidget {
  const PrinterSetupScreen({super.key});

  @override
  State<PrinterSetupScreen> createState() => _PrinterSetupScreenState();
}

class _PrinterSetupScreenState extends State<PrinterSetupScreen> {
  final PrinterService _printerService = PrinterService();
  List<BluetoothInfo> availableDevices = [];
  bool isScanning = false;
  bool isConnecting = false;
  String _language = 'ENG';
  var log = Logger();

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  Future<void> initializeScreen() async {
    final hasPermissions = await BluetoothPermissionHandler.checkAndRequestPermissions(context);

    if (!hasPermissions) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_language == 'ENG' ? 'Bluetooth permissions are required' : 'Ruhusa ya kuunganisha na bluetooth inahitajika'),
            action: SnackBarAction(
              label: _language == 'ENG' ? 'Retry' : 'Jaribu tena',
              onPressed: initializeScreen,
            ),
          ),
        );
      }
      return;
    }

    _checkExistingPrinter();
  }

  Future<void> _checkExistingPrinter() async {
    final info = await _printerService.getSavedPrinterInfo();
    if (info['address'] != null && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Existing Printer Found'),
          content: Text(
             _language == 'ENG' ? 'Printer "${info['name']}" is already configured.\n\nDo you want to reconfigure?' : 'Printer "${info['name']}" imeshaunganishwa tayari.\n\nDo you want to unataka ubadilishe?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_language == 'ENG' ? 'Keep Current' : 'Baki nayo'),
            ),
            TextButton(
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.yellow.shade600)),
              onPressed: () {
                Navigator.pop(context);
                _printerService.clearSavedPrinter();
                _scanForPrinters();
              },
              child: Text(_language == 'ENG' ? 'Reconfigure' : 'Badilisha', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
    } else {
      _scanForPrinters();
    }
  }

  Future<void> _scanForPrinters() async {
    setState(() {
      isScanning = true;
      availableDevices.clear();
    });

    try {
      // Check if Bluetooth is available
      final bool bluetoothAvailable = await PrintBluetoothThermal.bluetoothEnabled;

      if (!bluetoothAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_language == 'ENG' ? 'Please enable Bluetooth' : 'Tafadhali wezesha bluetooth')),
          );
        }
        return;
      }

      // Scan for Bluetooth devices
      List<BluetoothInfo> devices = await PrintBluetoothThermal.pairedBluetooths;

      setState(() {
        availableDevices = devices;
      });

      log.d('Found ${devices.length} paired printers');
    } catch (e) {
      log.e('Scan error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    }
  }

  Future<void> _connectToPrinter(BluetoothInfo device) async {
    setState(() {
      isConnecting = true;
    });

    bool success = await _printerService.establishConnection(device);

    if (success) {
      await _printerService.savePrinter(device);

      // Test print
      await _printerService.printReceipt('TEST PRINT',
          additionalLines: ['Configuration Successful', 'Printer: ${device.name}']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_language == 'ENG' ? 'Printer configured successfully!' : 'Printer imeunganishwa kikamilifu')),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_language == 'ENG' ? 'Failed to connect to printer' : 'Imeshindwa kuunganisha na printer kikamilifu')),
        );
      }
    }

    setState(() {
      isConnecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_language == 'ENG' ? 'Printer Setup' : 'Unganisha Printer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFC107)),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 22,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButton<String>(
                value: _language,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'ENG', child: Text('ENG')),
                  DropdownMenuItem(value: 'SWL', child: Text('SWL')),
                ],
                onChanged: (value) {
                  setState(() => _language = value!);
                },
              ),
            ),
          ),
          SizedBox(width: 10,),
          if (!isScanning && !isConnecting)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _scanForPrinters,
            ),
          SizedBox(width: 8,),
        ],
      ),
      body: isConnecting
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(_language == 'ENG' ? 'Connecting to printer...' : 'Inaunganisha na printer...'),
          ],
        ),
      )
          : Column(
        children: [
          if (isScanning) LinearProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              _language == 'ENG' ? 'Select your thermal printer from the list below:' : 'Chagua printer yako kutoka kwenye orodha hapo chini',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.yellow.shade600),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _language == 'ENG' ? 'Make sure your printer is turned on and paired in Bluetooth settings.' : 'Hakikisha printer yako imewashwa na kuunganishwa kwa njia ya bluetooth',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: availableDevices.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isScanning
                        ? Icons.bluetooth_searching
                        : Icons.bluetooth_disabled,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    isScanning
                        ? (_language == 'ENG' ? 'Scanning for printers...' : 'Inatafuta printer...')
                        : (_language == 'ENG' ? 'No paired printers found' : 'Hakuna printer iliyopatikana'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (!isScanning)
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: ElevatedButton.icon(
                        onPressed: _scanForPrinters,
                        icon: Icon(Icons.search),
                        label: Text(_language == 'ENG' ? 'Scan Again' : 'Tafuta tena'),
                      ),
                    ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: availableDevices.length,
              itemBuilder: (context, index) {
                final device = availableDevices[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.print,
                        size: 40, color: Colors.blue),
                    title: Text(
                      device.name.isEmpty
                          ? 'Unknown Device'
                          : device.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(device.macAdress),
                    trailing: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.yellow.shade600), foregroundColor: WidgetStateProperty.all(Colors.white)),
                      onPressed: () => _connectToPrinter(device),
                      child: Text(_language == 'ENG' ? 'Connect' : 'Unga'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
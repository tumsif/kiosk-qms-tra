import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  BluetoothInfo? _connectedPrinter;
  bool _isConnected = false;
  String? _savedPrinterAddress;

  static const String PRINTER_ADDRESS_KEY = 'saved_printer_address';
  static const String PRINTER_NAME_KEY = 'saved_printer_name';

  bool get isConnected => _isConnected;
  String? get printerName => _connectedPrinter?.name;

  var log = Logger();

  /// Initialize printer on app start
  Future<bool> initialize() async {
    log.i('[PrinterService] Initializing...');

    // Load saved printer address
    final prefs = await SharedPreferences.getInstance();
    _savedPrinterAddress = prefs.getString(PRINTER_ADDRESS_KEY);

    if (_savedPrinterAddress == null) {
      log.e('[PrinterService] No saved printer found');
      return false;
    }

    log.i('[PrinterService] Attempting to connect to saved printer: $_savedPrinterAddress');
    return await _connectToSavedPrinter();
  }

  /// Connect to previously saved printer
  Future<bool> _connectToSavedPrinter() async {
    try {
      // Get list of paired devices
      List<BluetoothInfo> devices = await PrintBluetoothThermal.pairedBluetooths;

      for (var device in devices) {
        if (device.macAdress == _savedPrinterAddress) {
          log.d('[PrinterService] Found printer: ${device.name}');
          return await establishConnection(device);
        }
      }

      log.d('[PrinterService] Saved printer not found in paired devices');
      return false;
    } catch (e) {
      log.e('[PrinterService] Error connecting to saved printer: $e');
      return false;
    }
  }

  /// Establish connection
  Future<bool> establishConnection(BluetoothInfo device) async {
    try {
      log.d('[PrinterService] Connecting to ${device.name}...');

      // Check if Bluetooth is enabled
      final bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!bluetoothEnabled) {
        log.e('[PrinterService] Bluetooth is not enabled');
        return false;
      }

      // Connect to the device
      bool success = await PrintBluetoothThermal.connect(macPrinterAddress: device.macAdress);

      if (success) {
        _connectedPrinter = device;
        _isConnected = true;
        log.i('[PrinterService] Successfully connected to printer!');
        return true;
      } else {
        log.e('[PrinterService] Failed to connect');
        return false;
      }
    } catch (e) {
      log.e('[PrinterService] Connection error: $e');
      _isConnected = false;
      return false;
    }
  }

  /// Print receipt
  Future<bool> printReceipt(String content, {List<String>? additionalLines}) async {
    if (!_isConnected || _connectedPrinter == null) {
      log.d('[PrinterService] Printer not connected');
      return false;
    }

    try {
      // Check connection status
      final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
      if (!connectionStatus) {
        log.e('[PrinterService] Lost connection to printer');
        _isConnected = false;
        return false;
      }

      // Create ESC/POS commands using esc_pos_utils_plus
      List<int> bytes = [];

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      // Reset printer
      bytes += generator.reset();

      // Print header
      bytes += generator.text(
        'QUEUE SYSTEM',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );

      bytes += generator.text(
        'Receipt',
        styles: PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.text(
        '--------------------------------',
        styles: PosStyles(align: PosAlign.center),
      );

      // Print main content (queue number)
      bytes += generator.text(
        content,
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
        ),
      );

      // Print additional lines
      if (additionalLines != null) {
        bytes += generator.emptyLines(1);
        for (var line in additionalLines) {
          bytes += generator.text(
            line,
            styles: PosStyles(align: PosAlign.center),
          );
        }
      }

      bytes += generator.text(
        '--------------------------------',
        styles: PosStyles(align: PosAlign.center),
      );

      bytes += generator.text(
        'Thank you!',
        styles: PosStyles(align: PosAlign.center),
      );

      bytes += generator.emptyLines(2);

      // Cut paper
      bytes += generator.cut();

      // Send to printer
      await PrintBluetoothThermal.writeBytes(bytes);

      log.i('[PrinterService] Print successful');
      return true;
    } catch (e) {
      log.e('[PrinterService] Print error: $e');
      return false;
    }
  }

  /// Save printer for future use
  Future<void> savePrinter(BluetoothInfo device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PRINTER_ADDRESS_KEY, device.macAdress);
    await prefs.setString(PRINTER_NAME_KEY, device.name);
    _savedPrinterAddress = device.macAdress;
    log.i('[PrinterService] Printer saved: ${device.name}');
  }

  /// Clear saved printer
  Future<void> clearSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PRINTER_ADDRESS_KEY);
    await prefs.remove(PRINTER_NAME_KEY);
    _savedPrinterAddress = null;
    await disconnect();
    log.i('[PrinterService] Saved printer cleared');
  }

  /// Disconnect printer
  Future<void> disconnect() async {
    if (_connectedPrinter != null) {
      await PrintBluetoothThermal.disconnect;
      _connectedPrinter = null;
      _isConnected = false;
      log.d('[PrinterService] Printer disconnected');
    }
  }

  /// Get saved printer info
  Future<Map<String, String?>> getSavedPrinterInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'address': prefs.getString(PRINTER_ADDRESS_KEY),
      'name': prefs.getString(PRINTER_NAME_KEY),
    };
  }

  /// Get available printers (paired Bluetooth devices)
  Future<List<BluetoothInfo>> getAvailablePrinters() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      log.e('[PrinterService] Error getting printers: $e');
      return [];
    }
  }

  /// Check connection validity
  Future<bool> isConnectionValid() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (e) {
      log.e('[PrinterService] Error checking connection: $e');
      return false;
    }
  }
}
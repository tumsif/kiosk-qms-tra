import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;

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

    final prefs = await SharedPreferences.getInstance();
    _savedPrinterAddress = prefs.getString(PRINTER_ADDRESS_KEY);

    if (_savedPrinterAddress == null) {
      log.e('[PrinterService] No saved printer found');
      return false;
    }

    log.i(
        '[PrinterService] Attempting to connect to saved printer: $_savedPrinterAddress');
    return await _connectToSavedPrinter();
  }

  /// Connect to previously saved printer
  Future<bool> _connectToSavedPrinter() async {
    try {
      List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      for (var device in devices) {
        if (device.macAdress == _savedPrinterAddress) {
          log.d('[PrinterService] Found printer: ${device.name}');
          return await establishConnection(device);
        }
      }

      log.d('[PrinterService] Saved printer not found');
      return false;
    } catch (e) {
      log.e('[PrinterService] Error connecting: $e');
      return false;
    }
  }

  /// Establish connection
  Future<bool> establishConnection(BluetoothInfo device) async {
    try {
      log.d('[PrinterService] Connecting to ${device.name}...');

      final bool bluetoothEnabled =
          await PrintBluetoothThermal.bluetoothEnabled;
      if (!bluetoothEnabled) {
        log.e('[PrinterService] Bluetooth disabled');
        return false;
      }

      bool success = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress,
      );

      if (success) {
        _connectedPrinter = device;
        _isConnected = true;
        log.i('[PrinterService] Connected successfully');
        return true;
      }
      return false;
    } catch (e) {
      log.e('[PrinterService] Connection error: $e');
      _isConnected = false;
      return false;
    }
  }

  /// Load logo
  Future<List<int>> _printLogo(Generator generator) async {
    final ByteData data = await rootBundle.load('assets/images/tra_logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) return [];
    return generator.image(image, align: PosAlign.center);
  }

  /// Print receipt
  Future<bool> printReceipt(
    String content, {
    List<String>? additionalLines,
  }) async {
    if (!_isConnected || _connectedPrinter == null) {
      log.d('[PrinterService] Printer not connected');
      return false;
    }

    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (!connectionStatus) {
        log.e('[PrinterService] Lost connection');
        _isConnected = false;
        return false;
      }

      List<int> bytes = [];

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      bytes += generator.reset();

      // ===== REPLACED QUEUE PART (ONLY CHANGE) =====
      bytes += await _printLogo(generator);

      bytes += generator.emptyLines(1);

      bytes += generator.text(
        'TRA - ARUSHA OFFICE',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
      // ===== END OF CHANGE =====

      bytes += generator.text(
        '--------------------------------',
        styles: PosStyles(align: PosAlign.center),
      );

      // Main content
      bytes += generator.text(
        content,
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
        ),
      );

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
      bytes += generator.cut();

      await PrintBluetoothThermal.writeBytes(bytes);
      log.i('[PrinterService] Print successful');
      return true;
    } catch (e) {
      log.e('[PrinterService] Print error: $e');
      return false;
    }
  }

  /// Save printer
  Future<void> savePrinter(BluetoothInfo device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PRINTER_ADDRESS_KEY, device.macAdress);
    await prefs.setString(PRINTER_NAME_KEY, device.name);
    _savedPrinterAddress = device.macAdress;
  }

  /// Clear saved printer
  Future<void> clearSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PRINTER_ADDRESS_KEY);
    await prefs.remove(PRINTER_NAME_KEY);
    _savedPrinterAddress = null;
    await disconnect();
  }

  /// Disconnect
  Future<void> disconnect() async {
    if (_connectedPrinter != null) {
      await PrintBluetoothThermal.disconnect;
      _connectedPrinter = null;
      _isConnected = false;
    }
  }

  /// Utilities
  Future<Map<String, String?>> getSavedPrinterInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'address': prefs.getString(PRINTER_ADDRESS_KEY),
      'name': prefs.getString(PRINTER_NAME_KEY),
    };
  }

  Future<List<BluetoothInfo>> getAvailablePrinters() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      log.e('[PrinterService] Error: $e');
      return [];
    }
  }

  Future<bool> isConnectionValid() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (e) {
      log.e('[PrinterService] Error: $e');
      return false;
    }
  }
}

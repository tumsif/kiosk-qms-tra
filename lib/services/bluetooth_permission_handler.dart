import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;


class BluetoothPermissionHandler {
  /// Check if all required Bluetooth permissions are granted
  static Future<bool> hasAllPermissions() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion >= 31) {
        // Android 12+ requires BLUETOOTH_SCAN and BLUETOOTH_CONNECT
        final scanStatus = await Permission.bluetoothScan.status;
        final connectStatus = await Permission.bluetoothConnect.status;
        return scanStatus.isGranted && connectStatus.isGranted;
      } else {
        // Android 11 and below
        final locationStatus = await Permission.location.status;
        return locationStatus.isGranted;
      }
    }
    return true; // iOS doesn't need manual permission requests for classic Bluetooth
  }

  /// Request all required Bluetooth permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion >= 31) {
        // Android 12+
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();

        return statuses.values.every((status) => status.isGranted);
      } else {
        // Android 11 and below
        final status = await Permission.location.request();
        return status.isGranted;
      }
    }
    return true;
  }

  /// Show permission dialog and handle the flow
  static Future<bool> checkAndRequestPermissions(BuildContext context) async {
    // First check if we already have permissions
    final hasPermissions = await hasAllPermissions();
    if (hasPermissions) {
      return true;
    }

    // Show explanation dialog
    final shouldRequest = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.bluetooth, color: Colors.blue),
            SizedBox(width: 8),
            Text('Bluetooth Permissions Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This app needs Bluetooth permissions to:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _PermissionItem(
              icon: Icons.search,
              text: 'Discover nearby printers',
            ),
            _PermissionItem(
              icon: Icons.link,
              text: 'Connect to thermal printers',
            ),
            _PermissionItem(
              icon: Icons.print,
              text: 'Print queue receipts',
            ),
            SizedBox(height: 12),
            Text(
              'Your privacy is protected. We only use these permissions for printer functionality.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Grant Permissions'),
          ),
        ],
      ),
    );

    if (shouldRequest != true) {
      return false;
    }

    // Request permissions
    final granted = await requestPermissions();

    if (!granted && context.mounted) {
      // Check if permissions were permanently denied
      final isPermanentlyDenied = await _checkPermanentlyDenied();

      if (isPermanentlyDenied) {
        _showSettingsDialog(context);
      } else {
        _showDeniedDialog(context);
      }
    }

    return granted;
  }

  /// Check if permissions are permanently denied
  static Future<bool> _checkPermanentlyDenied() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion >= 31) {
        final scanStatus = await Permission.bluetoothScan.status;
        final connectStatus = await Permission.bluetoothConnect.status;
        return scanStatus.isPermanentlyDenied || connectStatus.isPermanentlyDenied;
      } else {
        final locationStatus = await Permission.location.status;
        return locationStatus.isPermanentlyDenied;
      }
    }
    return false;
  }

  /// Show dialog when permissions are denied
  static void _showDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissions Denied'),
        content: Text(
          'Bluetooth permissions are required to use the printer. Please grant the permissions to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show dialog to open app settings
  static void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Open Settings'),
        content: Text(
          'Bluetooth permissions have been permanently denied. Please enable them in app settings to use the printer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Get Android SDK version
  static Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;

    try {
      // This is a simplified version - you might want to use a package
      // like device_info_plus for more accurate version detection
      return 31; // Assume modern Android by default
    } catch (e) {
      return 31;
    }
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PermissionItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
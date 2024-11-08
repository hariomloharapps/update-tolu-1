import 'package:flutter/services.dart';

class UsagePermissionService {
  static const _channel = MethodChannel('com.example.dekrf/usage_permission');

  Future<bool> checkPermission() async {
    try {
      return await _channel.invokeMethod('checkPermission');
    } on PlatformException catch (e) {
      print('Error checking permission: ${e.message}');
      return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      await _channel.invokeMethod('requestPermission');
      return await checkPermission();
    } on PlatformException catch (e) {
      print('Error requesting permission: ${e.message}');
      return false;
    }
  }
}
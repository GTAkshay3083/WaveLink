import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoService {
  static const _deviceIdKey = 'device_id';

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Uuid _uuid = const Uuid();

  /// Returns a persistent UUID for this installation.
  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    final existingId = prefs.getString(_deviceIdKey);

    if (existingId != null && existingId.isNotEmpty) {
      return existingId;
    }

    final newId = _uuid.v4();

    await prefs.setString(_deviceIdKey, newId);

    return newId;
  }

  /// Returns a human-readable device name.
  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;

      final manufacturer = info.manufacturer.trim();
      final model = info.model.trim();

      if (manufacturer.isEmpty) {
        return model;
      }

      return '$manufacturer $model';
    }

    if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;

      return info.name;
    }

    return Platform.operatingSystem;
  }

  /// Display name shown inside WaveLink.
  ///
  /// Later this will come from user settings.
  Future<String> getDisplayName() async {
    return getDeviceName();
  }
}
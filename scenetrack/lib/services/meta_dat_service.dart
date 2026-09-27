import 'dart:async';

import 'package:flutter/services.dart';

class MetaDatService {
  MetaDatService._();

  static final MetaDatService instance = MetaDatService._();

  static const MethodChannel _methodChannel = MethodChannel(
    'com.scenetrack/meta_dat/methods',
  );

  static const EventChannel _eventChannel = EventChannel(
    'com.scenetrack/meta_dat/events',
  );

  Stream<Map<String, dynamic>>? _events;

  Stream<Map<String, dynamic>> get events {
    return _events ??= _eventChannel.receiveBroadcastStream().map(
      (event) => Map<String, dynamic>.from(event as Map),
    );
  }

  Future<void> startRegistration() {
    return _methodChannel.invokeMethod<void>('startRegistration');
  }

  Future<void> startUnregistration() {
    return _methodChannel.invokeMethod<void>('startUnregistration');
  }

  Future<void> requestCameraPermission() {
    return _methodChannel.invokeMethod<void>('requestCameraPermission');
  }

  Future<void> startStream() {
    return _methodChannel.invokeMethod<void>('startStream');
  }

  Future<void> stopStream() {
    return _methodChannel.invokeMethod<void>('stopStream');
  }
}

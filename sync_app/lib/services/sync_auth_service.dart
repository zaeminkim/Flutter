import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sync_app/models/sync_api_models.dart';
import 'package:sync_app/services/sync_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SyncAuthService {
  SyncAuthService({required SyncApiService api, FlutterSecureStorage? storage})
    : _api = api,
      _storage = storage ?? const FlutterSecureStorage();

  static const _sessionTokenKey = 'sync_session_token';
  static const _sessionExpiryKey = 'sync_session_expiry';
  static const _pkceVerifierKey = 'sync_pkce_verifier';

  final SyncApiService _api;
  final FlutterSecureStorage _storage;

  Future<void> beginGoogleConnection() async {
    final verifier = _createCodeVerifier();
    final challenge = base64Url
        .encode(sha256.convert(utf8.encode(verifier)).bytes)
        .replaceAll('=', '');

    await _storage.write(key: _pkceVerifierKey, value: verifier);

    try {
      final start = await _api.startMobileAuth(challenge);
      final launched = await launchUrl(
        start.authorizationUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw const SyncApiException(message: 'Google 로그인 화면을 열지 못했습니다.');
      }
    } catch (_) {
      await _storage.delete(key: _pkceVerifierKey);
      rethrow;
    }
  }

  Future<MobileAuthSession> completeGoogleConnection(Uri appLink) async {
    if (appLink.scheme != 'https' ||
        appLink.host != 'sync-backend-c2lv.onrender.com' ||
        appLink.path != '/auth/android/complete') {
      throw const SyncApiException(message: '지원하지 않는 로그인 완료 링크입니다.');
    }

    final code = appLink.queryParameters['code'];
    final verifier = await _storage.read(key: _pkceVerifierKey);
    if (code == null || code.isEmpty || verifier == null) {
      throw const SyncApiException(message: '로그인 정보가 만료되었습니다. 다시 연결해 주세요.');
    }

    final session = await _api.exchangeMobileAuth(
      code: code,
      codeVerifier: verifier,
    );
    final expiresAt = DateTime.now()
        .add(Duration(seconds: session.expiresIn))
        .millisecondsSinceEpoch;

    await _storage.write(key: _sessionTokenKey, value: session.sessionToken);
    await _storage.write(key: _sessionExpiryKey, value: expiresAt.toString());
    await _storage.delete(key: _pkceVerifierKey);
    return session;
  }

  Future<String?> readValidSessionToken() async {
    final token = await _storage.read(key: _sessionTokenKey);
    final expiresAtRaw = await _storage.read(key: _sessionExpiryKey);
    final expiresAt = int.tryParse(expiresAtRaw ?? '');

    if (token == null ||
        expiresAt == null ||
        DateTime.now().millisecondsSinceEpoch >= expiresAt) {
      await clearSession();
      return null;
    }
    return token;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _sessionTokenKey);
    await _storage.delete(key: _sessionExpiryKey);
  }

  String _createCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(64, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

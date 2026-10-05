import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sync_app/models/sync_api_models.dart';

class SyncApiService {
  SyncApiService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _baseUri = Uri.parse(
    'https://sync-backend-c2lv.onrender.com',
  );

  final http.Client _client;

  Future<DirectRecommendation> recommendDirect(
    String imagePath, {
    String? requestId,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      _baseUri.resolve('/api/v1/recommend/direct'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    if (requestId != null) {
      request.fields['request_id'] = requestId;
    }

    final streamedResponse = await _client
        .send(request)
        .timeout(const Duration(minutes: 2));
    final response = await http.Response.fromStream(streamedResponse);
    final json = _decodeResponse(response);
    return DirectRecommendation.fromJson(json);
  }

  Future<MobileAuthStart> startMobileAuth(String codeChallenge) async {
    final response = await _client
        .post(
          _baseUri.resolve('/api/v1/auth/google/mobile/start'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'code_challenge': codeChallenge,
            'code_challenge_method': 'S256',
          }),
        )
        .timeout(const Duration(seconds: 30));
    return MobileAuthStart.fromJson(_decodeResponse(response));
  }

  Future<MobileAuthSession> exchangeMobileAuth({
    required String code,
    required String codeVerifier,
  }) async {
    final response = await _client
        .post(
          _baseUri.resolve('/api/v1/auth/mobile/exchange'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'code': code, 'code_verifier': codeVerifier}),
        )
        .timeout(const Duration(seconds: 30));
    return MobileAuthSession.fromJson(_decodeResponse(response));
  }

  Future<AuthConnection> getGoogleStatus(String sessionToken) async {
    final response = await _client
        .get(
          _baseUri.resolve('/api/v1/auth/google/status'),
          headers: {'Authorization': 'Bearer $sessionToken'},
        )
        .timeout(const Duration(seconds: 30));
    return AuthConnection.fromJson(_decodeResponse(response));
  }

  Future<CreatedPlaylist> createPlaylist({
    required String sessionToken,
    required String recommendationId,
    required String title,
  }) async {
    final response = await _client
        .post(
          _baseUri.resolve('/api/v1/playlists'),
          headers: {
            'Authorization': 'Bearer $sessionToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'recommendation_id': recommendationId,
            'title': title,
            'privacy_status': 'private',
          }),
        )
        .timeout(const Duration(minutes: 1));
    return CreatedPlaylist.fromJson(_decodeResponse(response));
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic>? json;
    if (response.bodyBytes.isNotEmpty) {
      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map<String, dynamic>) {
          json = decoded;
        }
      } on FormatException {
        // The status-based error below is more useful than leaking HTML/text.
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = json?['error'] as Map<String, dynamic>?;
      throw SyncApiException(
        statusCode: response.statusCode,
        code: error?['code'] as String?,
        message:
            error?['message'] as String? ??
            '서버 요청에 실패했습니다. (${response.statusCode})',
      );
    }

    if (json == null) {
      throw const SyncApiException(message: '서버 응답 형식이 올바르지 않습니다.');
    }
    return json;
  }
}

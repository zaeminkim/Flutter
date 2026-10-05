class SyncApiException implements Exception {
  const SyncApiException({required this.message, this.statusCode, this.code});

  final int? statusCode;
  final String? code;
  final String message;

  bool get isAuthenticationError =>
      statusCode == 401 ||
      code == 'MOBILE_SESSION_INVALID' ||
      code == 'YOUTUBE_NOT_CONNECTED' ||
      code == 'YOUTUBE_AUTH_EXPIRED';

  @override
  String toString() => message;
}

class DirectRecommendation {
  const DirectRecommendation({
    required this.recommendationId,
    required this.sceneDescription,
    required this.playlistTitle,
    required this.targetTrackCount,
    required this.partial,
    required this.languagePolicy,
    required this.tracks,
  });

  factory DirectRecommendation.fromJson(Map<String, dynamic> json) {
    final scene = json['scene'] as Map<String, dynamic>? ?? const {};
    final playlist = json['playlist'] as Map<String, dynamic>? ?? const {};
    final rawTracks = json['tracks'] as List<dynamic>? ?? const [];

    return DirectRecommendation(
      recommendationId: json['recommendation_id'] as String,
      sceneDescription: scene['description'] as String,
      playlistTitle: playlist['title'] as String,
      targetTrackCount: (json['target_track_count'] as num).toInt(),
      partial: json['partial'] as bool,
      languagePolicy: LanguagePolicy.fromJson(
        json['language_policy'] as Map<String, dynamic>,
      ),
      tracks: rawTracks
          .map((item) => DirectTrack.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final String recommendationId;
  final String sceneDescription;
  final String playlistTitle;
  final int targetTrackCount;
  final bool partial;
  final LanguagePolicy languagePolicy;
  final List<DirectTrack> tracks;
}

class LanguagePolicy {
  const LanguagePolicy({
    required this.requiredKoreanTracks,
    required this.actualKoreanTracks,
    required this.satisfied,
  });

  factory LanguagePolicy.fromJson(Map<String, dynamic> json) {
    return LanguagePolicy(
      requiredKoreanTracks: (json['required_korean_tracks'] as num).toInt(),
      actualKoreanTracks: (json['actual_korean_tracks'] as num).toInt(),
      satisfied: json['satisfied'] as bool,
    );
  }

  final int requiredKoreanTracks;
  final int actualKoreanTracks;
  final bool satisfied;
}

class DirectTrack {
  const DirectTrack({
    required this.rank,
    required this.artist,
    required this.trackTitle,
    required this.lyricLanguage,
    required this.koreanEligible,
    required this.albumTitle,
    required this.albumArtworkUrl,
    required this.videoId,
    required this.youtubeTitle,
    required this.youtubeThumbnailUrl,
    required this.fitScore,
  });

  factory DirectTrack.fromJson(Map<String, dynamic> json) {
    return DirectTrack(
      rank: (json['rank'] as num).toInt(),
      artist: json['artist'] as String,
      trackTitle: json['track_title'] as String,
      lyricLanguage: json['lyric_language'] as String,
      koreanEligible: json['korean_eligible'] as bool,
      albumTitle: json['album_title'] as String?,
      albumArtworkUrl: json['album_artwork_url'] as String?,
      videoId: json['video_id'] as String,
      youtubeTitle: json['youtube_title'] as String,
      youtubeThumbnailUrl: json['youtube_thumbnail_url'] as String,
      fitScore: (json['fit_score'] as num).toDouble(),
    );
  }

  final int rank;
  final String artist;
  final String trackTitle;
  final String lyricLanguage;
  final bool koreanEligible;
  final String? albumTitle;
  final String? albumArtworkUrl;
  final String videoId;
  final String youtubeTitle;
  final String youtubeThumbnailUrl;
  final double fitScore;

  String? get artworkUrl {
    final albumArtwork = albumArtworkUrl?.trim();
    if (albumArtwork != null && albumArtwork.isNotEmpty) {
      return albumArtwork;
    }

    final youtubeArtwork = youtubeThumbnailUrl.trim();
    return youtubeArtwork.isEmpty ? null : youtubeArtwork;
  }
}

class MobileAuthStart {
  const MobileAuthStart({
    required this.authorizationUrl,
    required this.expiresIn,
  });

  factory MobileAuthStart.fromJson(Map<String, dynamic> json) {
    return MobileAuthStart(
      authorizationUrl: Uri.parse(json['authorization_url'] as String),
      expiresIn: (json['expires_in'] as num).toInt(),
    );
  }

  final Uri authorizationUrl;
  final int expiresIn;
}

class MobileAuthSession {
  const MobileAuthSession({
    required this.sessionToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory MobileAuthSession.fromJson(Map<String, dynamic> json) {
    return MobileAuthSession(
      sessionToken: json['session_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );
  }

  final String sessionToken;
  final String tokenType;
  final int expiresIn;
}

class AuthConnection {
  const AuthConnection({
    required this.connected,
    this.channelId,
    this.channelTitle,
  });

  factory AuthConnection.fromJson(Map<String, dynamic> json) {
    final youtube = json['youtube'] as Map<String, dynamic>?;
    return AuthConnection(
      connected: json['connected'] as bool,
      channelId: youtube?['channel_id'] as String?,
      channelTitle: youtube?['channel_title'] as String?,
    );
  }

  final bool connected;
  final String? channelId;
  final String? channelTitle;
}

class CreatedPlaylist {
  const CreatedPlaylist({
    required this.id,
    required this.title,
    required this.privacyStatus,
    required this.url,
    required this.requestedCount,
    required this.addedCount,
    required this.failedCount,
    required this.partial,
  });

  factory CreatedPlaylist.fromJson(Map<String, dynamic> json) {
    final playlist = json['playlist'] as Map<String, dynamic>;
    return CreatedPlaylist(
      id: playlist['id'] as String,
      title: playlist['title'] as String,
      privacyStatus: playlist['privacy_status'] as String,
      url: Uri.parse(playlist['url'] as String),
      requestedCount: (json['requested_count'] as num).toInt(),
      addedCount: (json['added_count'] as num).toInt(),
      failedCount: (json['failed_count'] as num).toInt(),
      partial: json['partial'] as bool,
    );
  }

  final String id;
  final String title;
  final String privacyStatus;
  final Uri url;
  final int requestedCount;
  final int addedCount;
  final int failedCount;
  final bool partial;

  Uri get youtubeMusicUrl =>
      Uri.https('music.youtube.com', '/playlist', <String, String>{'list': id});
}

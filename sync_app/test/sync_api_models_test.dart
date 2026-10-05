import 'package:flutter_test/flutter_test.dart';
import 'package:sync_app/models/sync_api_models.dart';

void main() {
  test('direct recommendation keeps partial tracks and artwork fallback', () {
    final recommendation = DirectRecommendation.fromJson({
      'recommendation_id': 'rec_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
      'scene': {'description': '비 내리는 카페 창가'},
      'playlist': {'title': 'Rainy Cafe Focus'},
      'target_track_count': 5,
      'partial': true,
      'language_policy': {
        'required_korean_tracks': 2,
        'actual_korean_tracks': 1,
        'satisfied': false,
      },
      'tracks': [
        {
          'rank': 1,
          'artist': 'Artist',
          'track_title': 'Track',
          'lyric_language': 'ko',
          'korean_eligible': true,
          'album_title': null,
          'album_artwork_url': ' ',
          'video_id': 'video',
          'youtube_title': 'Artist - Track',
          'youtube_thumbnail_url': 'https://example.com/thumb.jpg',
          'thumbnail_url': 'https://example.com/thumb.jpg',
          'fit_score': 0.9,
        },
      ],
    });

    expect(recommendation.partial, isTrue);
    expect(recommendation.tracks, hasLength(1));
    expect(
      recommendation.tracks.single.artworkUrl,
      'https://example.com/thumb.jpg',
    );
  });

  test('created playlist builds a YouTube Music URL', () {
    final playlist = CreatedPlaylist.fromJson({
      'playlist': {
        'id': 'PL123',
        'title': 'Focus',
        'privacy_status': 'private',
        'url': 'https://www.youtube.com/playlist?list=PL123',
      },
      'submitted_count': 1,
      'requested_count': 1,
      'added_count': 1,
      'failed_count': 0,
      'partial': false,
      'items': [],
    });

    expect(playlist.youtubeMusicUrl.host, 'music.youtube.com');
    expect(playlist.youtubeMusicUrl.queryParameters['list'], 'PL123');
  });
}

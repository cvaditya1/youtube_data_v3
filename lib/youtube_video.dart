import 'package:googleapis/youtube/v3.dart';

class YtVideo{
  PlaylistItem _playlistItem;
  PlaylistItem get playListItem => _playlistItem;

  YtVideo(PlaylistItem playlistItem){
    this._playlistItem = playlistItem;

    _extractPlaylistItemId();
    _extractVideoItemId();
    _extractChannelId();
    _extractPlaylistItemThumbnail();
    _extractPlaylistItemTitle();
    _extractPlaylistItemDescription();
    _extractPlaylistItemPublishedAt();
    _extractPlaylistItemPosition();
  }

  ThumbnailDetails thumbnailDetails;
  String id, videoId, title, description, duration, channelId;
  DateTime publishedAt;
  int position;

  _extractPlaylistItemId() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    id = snippet?.playlistId ?? null;
  }

  _extractVideoItemId() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    videoId = snippet?.resourceId?.videoId ?? null;
  }

  _extractChannelId() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    channelId = snippet?.resourceId?.channelId ?? null;
  }

  _extractPlaylistItemThumbnail() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    thumbnailDetails = snippet?.thumbnails ?? null;
  }

  _extractPlaylistItemTitle() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    title = snippet?.title ?? null;
  }

  _extractPlaylistItemDescription() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    description = snippet?.description ?? null;
  }

  _extractPlaylistItemPublishedAt() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    publishedAt = snippet?.publishedAt ?? null;
  }

  _extractPlaylistItemPosition() {
    PlaylistItemSnippet snippet = _playlistItem?.snippet ?? null;
    position = snippet?.position ?? null;
  }
}
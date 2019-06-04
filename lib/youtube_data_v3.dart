library youtube_data_v3;

import 'package:http/http.dart' as http;
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:youtube_data_v3/youtube_channel.dart';

class YoutubeV3 {
  static final YoutubeV3 _singleton = new YoutubeV3._internal();

  factory YoutubeV3() {
    return _singleton;
  }

  YoutubeV3._internal() {
    _createClientWithApiKey();
  }

  http.Client _client;

  String _apiKey;
  String get apiKey => _apiKey;

  YoutubeApi youtubeApi;

  _createClientWithApiKey() {
    if (_apiKey != null && _apiKey.isNotEmpty) {
      _client = clientViaApiKey(_apiKey);
      youtubeApi = new YoutubeApi(_client);
    }
  }

  init(String apiKey) {
    this.apiKey = apiKey;
  }

  set apiKey(String key) {
    bool clientChanged = false;
    if (key != null && key.isNotEmpty && key != _apiKey) clientChanged = true;
    if (clientChanged) {
      _apiKey = key;
      _createClientWithApiKey();
    }
  }

  Future<YtChannel> getChannelFromId(String channelId) async {
    if (youtubeApi == null || (channelId?.isEmpty ?? true)) return null;
    var part = "snippet,contentDetails";
    ChannelListResponse response =
        await youtubeApi.channels.list(part, id: channelId);
    List<Channel> channelList = response?.items ?? [];
    return (channelList.length) > 0
        ? YtChannel(channelList[0], youtubeApi: youtubeApi)
        : null;
  }
}

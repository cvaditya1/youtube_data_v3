import 'package:flutter_test/flutter_test.dart';

import 'package:youtube_data_v3/youtube_data_v3.dart';
import 'package:youtube_data_v3/youtube_channel.dart';
import 'package:youtube_data_v3/youtube_video.dart';

void main() {
  const String API_KEY = "";// API key
  const String CHANNEL_ID = "";// Channel Id

  String expectedChannelTitle = "";//Expected Title
  String expectedVideoTitle = "";//Expected video title
  String expectedVideoDuration = "3:41";//Valid format is 3:41 or 1:03:41 or 1:00:41 or 41 or 11:03:41

  String expectedUploadsPlaylistId = "";

  test('Test Youtube API to get channel from Id and video list from channel', () async {
    final ytApi = YoutubeV3();
    ytApi.init("key1");
    expect(ytApi.apiKey, "key1");
    ytApi.apiKey = API_KEY;
    expect(ytApi.apiKey, API_KEY);
    YtChannel channel = await ytApi.getChannelFromId(CHANNEL_ID);
    expect(channel.title, expectedChannelTitle);
    expect(channel.uploadsId, expectedUploadsPlaylistId);

    List<YtVideo> videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true);
    expect(videoList.length, 10);

    expect(videoList[0].title, expectedVideoTitle);
    expect(videoList[0].position, 0);
    expect(videoList[0].duration, expectedVideoDuration);

    videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true, showNextPage: true);
    expect(videoList.length, 10);

    expect(videoList[0].position, 10);
    expect(videoList[9].position, 19);

    videoList = await channel.getPageOfVideos(numResults: 5, showDuration: true, showNextPage: true);
    expect(videoList.length, 5);

    expect(videoList[0].position, 20);
    expect(videoList[4].position, 24);

    videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true, showPrevPage: true);
    expect(videoList.length, 10);

    expect(videoList[0].position, 10);
    expect(videoList[9].position, 19);

    videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true);
    expect(videoList.length, 10);

    expect(videoList[0].position, 0);
    expect(videoList[9].position, 9);

    //expect(ytApi.addOne(0), 1);
    //expect(() => ytApi.addOne(null), throwsNoSuchMethodError);
  });
}

import 'package:youtube_data_v3/youtube_data_v3.dart';
import 'package:youtube_data_v3/youtube_channel.dart';
import 'package:youtube_data_v3/youtube_video.dart';

main(List<String> arguments) async {

  const String API_KEY = "";// API key from Google console
  const String CHANNEL_ID = "";// Channel Id of the youtube channel to fetch videos from

  final ytApi = YoutubeV3();
  ytApi.init(API_KEY);
  YtChannel channel = await ytApi.getChannelFromId(CHANNEL_ID);
  print(channel.title);
  print(channel.uploadsId);

  List<YtVideo> videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true);
  print(videoList.length);

  //title of the video
  print(videoList[0].title);
  //position of the video in the list of videos from the page received
  print(videoList[0].position);
  //duration of the video (only present when show duration is set to true)
  print(videoList[0].duration);

  //Url of the thumbnail of the video
  print(videoList[0].thumbnailDetails.default_.url);
}

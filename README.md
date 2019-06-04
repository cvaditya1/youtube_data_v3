# youtube_data_v3

[![pub package](https://img.shields.io/badge/pub-v0.0.1-green.svg)](https://pub.dev/packages/youtube_data_v3/)

Package contains functions to access Youtube Data API V3 via the API key. 

The package uses Api's with parameters having less quota's.

## Features

* Channel & videos from channel id.

## Usage
To use this plugin add 'youtube_data_v3' as a dependency in [pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart

import 'package:youtube_data_v3/youtube_data_v3.dart';
import 'package:youtube_data_v3/youtube_channel.dart';
import 'package:youtube_data_v3/youtube_video.dart';

final ytApi = YoutubeV3();
ytApi.init("API KEY");
YtChannel channel = await ytApi.getChannelFromId("CHANNEL ID");
//Get title of channel
print(channel.title);
//Get the channel uploads(All the videos in a channel) id
print(channel.uploadsId);
//Get the channel Description
print(channel.description);
//Get the channel url
print(channel.customUrl);
//Get the channel thumbnail
print(channel.thumbnailDetails);
ThumbnailDetails channelTumbnail = channel.thumbnailDetails;
//Get the channel publised date
DateTime chPubTime = channel.publishedAt;
//Get google youtube api channel
Channel gApi = channel.gApiChannel;

//Get the first page of videos from channel. Optional: Max num of Results, Optional: get duration of video also (defaults to false)
List<YtVideo> videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true);

//Shows the next page of videos from the last time a call was made to getPageOfVideos
videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true, showNextPage: true);
//gives previous page of videos from the last time a call was made to getPageOfVideos
videoList = await channel.getPageOfVideos(numResults: 10, showDuration: true, showPrevPage: true);

//YtVideo
//Get title of video
print(videoList[0].title);
//Position of video in the list of videos received
print(videoList[0].position);
//Get duration of video
print(videoList[0].duration);//Showed as 10:41 or 1:10:41
//Get description
print(videoList[0].description);
//Get Video id
print(videoList[0].videoId);
//Get thumbnail
ThumbnailDetails videoThumbnail = videoList[0].thumbnailDetails;
// Get published date
DateTime vidPubTime = videoList[0].publishedAt;
//Get channel id
print(videoList[0].channelId);
//Get playlist id of the video
print(videoList[0].id);
//Get google youtube api video item
PlaylistItem videoItem = videoList[0].videoItem;

```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

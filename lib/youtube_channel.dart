import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_data_v3/youtube_video.dart';

class YtChannel{

  YoutubeApi _ytApi;
  Channel _channel;
  Channel get gApiChannel => _channel;

  YtChannel(Channel channel, {YoutubeApi youtubeApi}){
    _channel = channel;
    if(youtubeApi != null) this._ytApi = youtubeApi;
    _extractChannelId();
    _extractChannelThumbnail();
    _extractChannelTitle();
    _extractChannelDescription();
    _extractChannelCustomUrl();
    _extractChannelPublishedAt();
    _extractChannelUploadsPlaylistId();
  }

  ThumbnailDetails thumbnailDetails;
  String id, title, description, customUrl, uploadsId;
  DateTime publishedAt;

  String _nextPageToken, _previousPageToken;
  int totalUploadVideosCount;

  _extractChannelId() {
    id = _channel?.id ?? null;
  }

  _extractChannelThumbnail() {
    ChannelSnippet snippet = _channel?.snippet ?? null;
    thumbnailDetails = snippet?.thumbnails ?? null;
  }

  _extractChannelTitle(){
    ChannelSnippet snippet = _channel?.snippet ?? null;
    title = snippet?.title ?? "";
  }

  _extractChannelDescription(){
    ChannelSnippet snippet = _channel?.snippet ?? null;
    description = snippet?.description ?? "";
  }

  _extractChannelCustomUrl(){
    ChannelSnippet snippet = _channel?.snippet ?? null;
    customUrl = snippet?.customUrl ?? "";
  }

  _extractChannelPublishedAt(){
    ChannelSnippet snippet = _channel?.snippet ?? null;
    publishedAt = snippet?.publishedAt ?? "";
  }

  _extractChannelUploadsPlaylistId(){
    ChannelContentDetails contentDetails = _channel?.contentDetails ?? null;
    ChannelContentDetailsRelatedPlaylists channelPlaylists = contentDetails?.relatedPlaylists ?? null;
    uploadsId = channelPlaylists?.uploads ?? null;
  }

  //ToDo: Required Limits for max result
  Future<List<YtVideo>> getPageOfVideos({int numResults, bool showDuration, bool showNextPage, bool showPrevPage}) async {
    if(_ytApi == null || (uploadsId?.isEmpty ?? true)) return null;
    var part = "snippet";

    bool getNextPage = false;
    bool getPreviousPage = false;
    if(showNextPage != null) getNextPage = showNextPage;
    if(showPrevPage != null) getPreviousPage = showPrevPage;
    if(showNextPage != null && showNextPage != null && showPrevPage == showNextPage){
      getNextPage = false;
      getPreviousPage = false;
    }

    String pageToken = (!getNextPage && !getPreviousPage) ? null : (getNextPage ? _nextPageToken : (getPreviousPage ? _previousPageToken : null));

    PlaylistItemListResponse response =  await _ytApi.playlistItems.list(part,playlistId: uploadsId ,maxResults: numResults, pageToken: pageToken);

    _nextPageToken = response?.nextPageToken ?? null;
    _previousPageToken = response?.prevPageToken ?? null;

    int totalResults = response?.pageInfo?.totalResults ?? 0;
    int resultsPerPage = response?.pageInfo?.resultsPerPage ?? 0;

    if(_nextPageToken != null && _previousPageToken == null){
      totalUploadVideosCount = totalResults < resultsPerPage ? totalResults : resultsPerPage;
    } else {
      if(_nextPageToken == null && _previousPageToken == null){
        totalUploadVideosCount = totalResults;
      }
    }

    return await _getNewVideoList(response, showDuration);
  }

  Future<List<YtVideo>> _getNewVideoList(PlaylistItemListResponse response, bool showDuration)async{
    List<PlaylistItem> playListItem = response?.items ?? [];
    List<YtVideo> videoList = [];
    for(PlaylistItem item in playListItem){
      YtVideo ytVideo = new YtVideo(item);
      videoList.add(ytVideo);
    }
    bool shouldFetchDuration = false;
    if(showDuration != null) shouldFetchDuration = showDuration;
    if(shouldFetchDuration){
      await _fetchVideoDetails(videoList);
    }
    return videoList;
  }

  Future _fetchVideoDetails(List<YtVideo> videoList) async {
    if(_ytApi == null || (videoList?.isEmpty ?? true)) return [];
    List<String> videoIdList = [];
    for(YtVideo item in videoList){
      videoIdList.add(item.videoId);
    }
    if(videoIdList.length > 0){
      String part = "contentDetails";
      String ids = videoIdList.join(",");
      VideoListResponse response = await _ytApi.videos.list(part, id: ids, maxResults: videoList.length);
      List<Video> videoListResp = response.items;

      await Future.forEach(videoListResp, (Video video) {
        YtVideo ytVideo = videoList.singleWhere((ytVideo) => ytVideo.videoId == video.id, orElse: () => null);
        ytVideo.duration = _getDuration(video?.contentDetails?.duration ?? "") ?? "";
      });
    }
  }

  String _getDuration(String duration){
    if(duration.isEmpty) return null;
    duration = duration.replaceFirst("PT", "");

    var validDuration = ["H", "M", "S"];
    if(!duration.contains(new RegExp(r'[HMS]'))){
      return null;
    }
    var hour = 0, min = 0, sec = 0;
    for(int i = 0; i< validDuration.length; i++){
      var index = duration.indexOf(validDuration[i]);
      if(index != -1){
        var valInString = duration.substring(0, index);
        var val = int.parse(valInString);
        if(i == 0) hour = val;
        else if(i == 1) min = val;
        else if(i == 2) sec = val;
        duration = duration.substring(valInString.length + 1);
      }
    }
    List buff = [];
    if(hour != 0){
      buff.add(hour.toString());
    }
    if(min < 10){
      if(hour != 0) buff.add(min.toString().padLeft(2,'0'));
      else buff.add(min.toString());
    } else {
      buff.add(min.toString().padLeft(2,'0'));
    }
    buff.add(sec.toString().padLeft(2,'0'));

    return buff.join(":");
  }
}
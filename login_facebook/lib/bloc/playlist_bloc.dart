import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';

class PlaylistBloc {
  PlaylistRepository _playlistRepository = PlaylistRepository();

  final _favoritePlaylistController = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get favotite_sink => _favoritePlaylistController.sink;
  Stream<List<Playlist>> get stream_favotite => _favoritePlaylistController.stream;

  final _top3PlaylistController = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get top3_sink => _top3PlaylistController.sink;
  Stream<List<Playlist>> get stream_top3 => _top3PlaylistController.stream;

   final _playlistWithPageController = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get playlistWIthPage_sink => _playlistWithPageController.sink;
  Stream<List<Playlist>> get stream_playlistWIthPage => _playlistWithPageController.stream;

  PlaylistBloc({@required PlaylistRepository playlistRepository})
      : assert(playlistRepository != null),
        _playlistRepository = playlistRepository;

  void getTop3Playlist() async{
    final tmp = await _playlistRepository.getTop3Playlists();
    top3_sink.add(tmp);
  } 
  void getUserFavoritesPlaylist() async{
    final tmp = await  _playlistRepository.getUserFavoritesPlaylist();
    favotite_sink.add(tmp);
  } 
  void getPlaylistWithPage(int page) async{
    final tmp = await  _playlistRepository.getPlaylists(page);
    playlistWIthPage_sink.add(tmp);
  } 
}
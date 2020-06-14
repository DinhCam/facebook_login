import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';



class SearchPlaylistBloc {
  PlaylistRepository _playlistRepository = PlaylistRepository();

  final _playlistWithPageController = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get playlistWIthPage_sink =>
      _playlistWithPageController.sink;
  Stream<List<Playlist>> get stream_playlistWIthPage =>
      _playlistWithPageController.stream;

  SearchPlaylistBloc({@required PlaylistRepository playlistRepository})
      : assert(playlistRepository != null),
        _playlistRepository = playlistRepository;

  void getPlaylistsBySearchkey(String searchKey) async{
    final tmp = await  _playlistRepository.getPlaylistsBySearchKey(searchKey);
    playlistWIthPage_sink.add(tmp);
  }

  
}

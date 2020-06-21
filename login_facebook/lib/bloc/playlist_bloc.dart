import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/states/home_page_state.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:loginfacebook/events/home_page_event.dart';

class HomePageBloc  extends Bloc<HomepageEvent, HomePageState> {
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

  HomePageBloc({@required PlaylistRepository playlistRepository})
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

  @override
  // TODO: implement initialState
  HomePageState get initialState => CreateState();

  @override
  Stream<HomePageState> mapEventToState(HomepageEvent event) async*{
   if (event is PageCreate) {  
     await getUserFavoritesPlaylist();
     await getTop3Playlist();
     await getPlaylistWithPage(0);
    yield CreateState();
    } else if (event is GetTop3) {
      await getTop3Playlist();
      yield LoadFinishState();
    } else if (event is GetFavorite) {
      await getUserFavoritesPlaylist();
      yield LoadFinishState();
    } else if (event is GetPlaylistSuggets) {
      await getPlaylistWithPage(0);
      yield LoadFinishState();
  } 
  }
}
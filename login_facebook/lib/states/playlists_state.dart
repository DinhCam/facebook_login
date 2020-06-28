import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/playlist.dart';

@immutable
abstract class PlaylistState extends Equatable {
  PlaylistState([List props = const []]) : super(props);
}

class Uninitialized extends PlaylistState {
}
class LoadFinishState  extends PlaylistState {
}
class ViewMoreBrandPlaylistsState  extends PlaylistState {
  List<Playlist> playlists;
  ViewMoreBrandPlaylistsState({Key key, @required this.playlists});
}
class LoadPlaylistsSubDetailFinishState  extends PlaylistState {
  List<Playlist> playlists;
  LoadPlaylistsSubDetailFinishState({Key key, @required this.playlists});
}
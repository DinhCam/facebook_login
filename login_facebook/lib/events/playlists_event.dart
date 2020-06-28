import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/playlist.dart';

@immutable
abstract class PlaylistsEvent  extends Equatable {
  PlaylistsEvent([List props = const []]) : super(props);
}

class Loading extends PlaylistsEvent {
  @override
  String toString() => 'Loading';
}

class ViewMoreBrandPlaylists extends PlaylistsEvent {
  List<Playlist> playlists;
  ViewMoreBrandPlaylists({Key key, @required this.playlists});
  @override
  String toString() => 'ViewMoreBrandPlaylists';
}
class LoadPlaylistsSubDetail extends PlaylistsEvent {
  List<Playlist> playlists;
  LoadPlaylistsSubDetail({Key key, @required this.playlists});
  @override
  String toString() => 'LoadPlaylistsSubDetail';
}

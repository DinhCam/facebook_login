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

class LoadSubcribeTopicState extends PlaylistState {
  BuildContext context;
  bool isSubcribe;
  String brandName;
  LoadSubcribeTopicState({Key key, @required this.isSubcribe,@required this.context,@required this.brandName});
}

class ChangeSuccess extends PlaylistState{
  BuildContext context;
  bool isSubcribe;
  String brandName;
  ChangeSuccess({Key key, @required this.isSubcribe,@required this.context,@required this.brandName});
}

class ChangeError extends PlaylistState{
  String error;
  ChangeError({Key key, @required this.error});
}
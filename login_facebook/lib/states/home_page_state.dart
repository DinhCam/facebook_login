import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/playlist.dart';

@immutable
abstract class HomePageState extends Equatable {
  HomePageState([List props = const []]) : super(props);
}

class LoadFinishState extends HomePageState {
}

class CreateState extends HomePageState {
}
class ViewPlaylists extends HomePageState {
}
class OnPushState extends HomePageState {
}

class DeleteSuccess extends HomePageState {
}
class Deletefail extends HomePageState {
}
class LoadFavoritePlaylistSuccess extends HomePageState {
  List<Playlist> list;
  LoadFavoritePlaylistSuccess({Key key, @required this.list});
}
class Tmp extends HomePageState {
}


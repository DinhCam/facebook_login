import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MediaEvent extends Equatable {
  
}

class PageCreateMedia extends MediaEvent {
  Playlist playlist;
  List<Playlist> listFavorite;
  PageCreateMedia({@required this.playlist, @required this.listFavorite}) : assert(playlist!=null);
  @override
  String toString() => 'PageCreate';
}


class AddPlaylistToMyList extends MediaEvent{
  List<Playlist> listFavorite;
  Playlist playlist;
  bool isMyList;
  AddPlaylistToMyList({@required this.playlist, @required this.isMyList,@required this.listFavorite}) : assert(playlist!=null && isMyList !=null);
}

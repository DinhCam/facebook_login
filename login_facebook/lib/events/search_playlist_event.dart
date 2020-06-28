import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SearchPlaylistsEvent  extends Equatable {
  
  SearchPlaylistsEvent([List props = const []]) : super(props);
}

class SearchSuggestPlaylist extends SearchPlaylistsEvent {
  String searchKey;
  SearchSuggestPlaylist({Key key, @required this.searchKey});
  @override
  String toString() => 'SearchSuggestPlaylist';
}
class SearchAllPlaylist extends SearchPlaylistsEvent {
  String searchKey;
  SearchAllPlaylist({Key key, @required this.searchKey});
  @override
  String toString() => 'SearchAllPlaylist';
}
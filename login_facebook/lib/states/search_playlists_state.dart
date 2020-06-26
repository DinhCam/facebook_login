import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SearchPlaylistState extends Equatable {
  SearchPlaylistState([List props = const []]) : super(props);
}

class Uninitialized extends SearchPlaylistState {
}
class SearchSuggestState extends SearchPlaylistState {
}
class SearchAllPlaylistsState extends SearchPlaylistState {
}
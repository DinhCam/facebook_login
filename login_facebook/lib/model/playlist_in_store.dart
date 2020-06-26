import 'dart:ffi';

import 'package:loginfacebook/model/category_playlist.dart';

class PlaylistInStore{
  String _id;
  double _priotity;
  int _numberOfPlays;
  String _storeId;
  String _playlistId;
  int _orderPlay;
  String _playlistName;
  String _imageUrl;
  List<CategoryPlaylist> _listCategoryPlaylists;
 String get id => _id;

 set id(String value) => _id = value;

 double get priotity => _priotity;

 set priotity(double value) => _priotity = value;

 int get numberOfPlays => _numberOfPlays;

 set numberOfPlays(int value) => _numberOfPlays = value;

 String get storeId => _storeId;

 set storeId(String value) => _storeId = value;

 String get playlistId => _playlistId;

 set playlistId(String value) => _playlistId = value;

 int get orderPlay => _orderPlay;

 set orderPlay(int value) => _orderPlay = value;

 String get playlistName => _playlistName;

 set playlistName(String value) => _playlistName = value;

 String get imageUrl => _imageUrl;

 set imageUrl(String value) => _imageUrl = value;

 List get listCategoryPlaylists => _listCategoryPlaylists;

 set listCategoryPlaylists(List value) => _listCategoryPlaylists = value;
 
 
 PlaylistInStore(
   {
      String id,
      double priotity,
      int numberOfPlays,
      String storeId,
      String playlistId,
      int orderPlay,
      String playlistName,
      String imageUrl,
      List<CategoryPlaylist> listCategoryPlaylists,
   }
 ) : _id=id,_priotity=priotity,_numberOfPlays=numberOfPlays,_storeId=storeId,_playlistId=playlistId
    ,_orderPlay=orderPlay,_playlistName=playlistName,_imageUrl=imageUrl,_listCategoryPlaylists=listCategoryPlaylists;

  factory PlaylistInStore.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new PlaylistInStore(
        id: json['Id'],
        priotity: json['Priotity'],
        numberOfPlays: json['NumberOfPlays'],
        storeId: json['StoreId'],
        playlistId: json["PlaylistId"],
        orderPlay: json['OrderPlay'],
        playlistName: json['PlaylistName'],
        imageUrl: json['ImageUrl'],
        listCategoryPlaylists: parseCategoryPlaylist(json)
        );
  }
  static List<CategoryPlaylist> parseCategoryPlaylist(jsonCategoryMedia){
    var list = jsonCategoryMedia['CategoryPlaylists'] as List;
    List<CategoryPlaylist> categoryMediaList=
      list.map((e) => CategoryPlaylist.fromJson(e)).toList();
      return categoryMediaList;
  }

}
import 'package:flutter/material.dart';

class CurrentMedia{
  String _id;
  String _mediaId;
  String _storeId;
  String _playlistId;
  DateTime _timeStart;
  DateTime _timeEnd;
  TimeOfDay _timeToPlay;
 String get id => _id;

 set id(String value) => _id = value;

 String get mediaId => _mediaId;

 set mediaId(String value) => _mediaId = value;

 String get storeId => _storeId;

 set storeId(String value) => _storeId = value;

 String get playlistId => _playlistId;

 set playlistId(String value) => _playlistId = value;
 CurrentMedia({
   String id,
  String mediaId,
  String storeId,
  String playlistId,
  DateTime timeStart,
  DateTime timeEnd,
  TimeOfDay timeToPlay
 }) : _id=id,_mediaId=mediaId,_storeId=storeId,_playlistId=playlistId,_timeStart=timeStart,_timeEnd=timeEnd,_timeToPlay=timeToPlay;
factory CurrentMedia.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new CurrentMedia(
        id: json['Id'],
        mediaId: json['MediaId'],
        storeId: json['StoreId'],
        playlistId: json['PlaylistId'],
        timeStart: DateTime.parse(json['TimeStart']),
        timeEnd: DateTime.parse(json['TimeEnd']),       
        timeToPlay: TimeOfDay.fromDateTime(DateTime.parse('2018-10-20 '+json['TimeToPlay'])),
        );
  }
}
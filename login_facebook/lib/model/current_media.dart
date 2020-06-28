import 'package:flutter/material.dart';

class CurrentMedia{
  String _id;
  String _mediaId;
  String _storeId;
  String _playlistId;
  DateTime _timeStart;
  DateTime _timeEnd;
  Duration _timeToPlay;
 String get id => _id;

 set id(String value) => _id = value;

 String get mediaId => _mediaId;

 set mediaId(String value) => _mediaId = value;

 String get storeId => _storeId;

 set storeId(String value) => _storeId = value;

 String get playlistId => _playlistId;

 set playlistId(String value) => _playlistId = value;

 DateTime get timeStart => _timeStart;
 set timeStart(DateTime value) => _timeStart= value;

 DateTime get timeEnd => _timeEnd;
 set timeEnd(DateTime value) => _timeEnd= value;

 Duration get timeToPlay => _timeToPlay;
 set timeToPlay(Duration value) => _timeToPlay= value;
 


 CurrentMedia({
   String id,
  String mediaId,
  String storeId,
  String playlistId,
  DateTime timeStart,
  DateTime timeEnd,
  Duration timeToPlay
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
        timeToPlay: parseDuration(json['TimeToPlay']),
        );
  }

  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
}
}
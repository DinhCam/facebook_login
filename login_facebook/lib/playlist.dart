import 'dart:math';
import 'authenticate.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Playlist {
  String Id;
  String PlaylistName;
  String ModifyBy;
  String ModifyDate;
  String CreateBy;
  String CreateDate;
  bool IsDelete;
  int DateFillter;
  String BrandId;
  int TimePlayed;
  String ImageUrl;
  Playlist(
      {this.Id,
      this.PlaylistName,
      this.BrandId,
      this.CreateBy,
      this.DateFillter,
      this.ImageUrl,
      this.IsDelete,
      this.ModifyBy,
      this.CreateDate,
      this.ModifyDate,
      this.TimePlayed});
  factory Playlist.fromJson(Map<String, dynamic> json) {
    return new Playlist(
      Id: json['userId'],
      PlaylistName: json['PlaylistName'],
      BrandId: json['BrandId'],
      CreateBy: json['CreateBy'],
      DateFillter: json['DateFillter'],
      ImageUrl: json['ImageUrl'],
      IsDelete: json['IsDelete'],
      ModifyBy: json['ModifyBy'],
      CreateDate: json['CreateDate'],
      ModifyDate: json['ModifyDate'],
      TimePlayed: json['TimePlayed'],
    );
  }
}

class UserFavoritePlaylists {
  List<Playlist> playList;
  UserFavoritePlaylists({this.playList});
}

List<Playlist> userFavoritePlaylists = new List();
List<Playlist> top3playlist = new List();
List<Playlist> playlists10 = new List();


Future<List<Playlist>> GetUserFavoritePlaylists() async {
  String url =
      'https://audiostreaming-dev-as.azurewebsites.net/api/Playlists/users';
  final http.Response response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + currentUserWithToken.Token
  });
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    List<dynamic> values = new List<dynamic>();
    values = json.decode(response.body);
    userFavoritePlaylists = new List();
    if (values.length > 0) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          userFavoritePlaylists.add(Playlist.fromJson(map));
        }
      }
    }
    return userFavoritePlaylists;
  } else {
    throw Exception('Failed to load playlist');
  }
}

Future<List<Playlist>> GetTop3Playlists() async {
  String url =
      'https://audiostreaming-dev-as.azurewebsites.net/api/Playlists?IsSort=true&IsDescending=true&IsPaging=true&PageNumber=0&PageLimitItem=3';
  final http.Response response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    List<dynamic> values = new List<dynamic>();
    values = json.decode(response.body);
    top3playlist = new List();
    if (values.length > 0) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          top3playlist.add(Playlist.fromJson(map));
        }
      }
    }
    return top3playlist;
  } else {
    throw Exception('Failed to load playlist');
  }
}

Future<List<Playlist>> Get10Playlists() async {
  String url =
      'https://audiostreaming-dev-as.azurewebsites.net/api/Playlists?IsSort=false&IsDescending=false&IsPaging=true&PageNumber=0&PageLimitItem=10';
  final http.Response response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if (response.statusCode == 200) {
    List<dynamic> values = new List<dynamic>();
    values = json.decode(response.body);
    playlists10 = new List();
    if (values.length > 0) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          playlists10.add(Playlist.fromJson(map));
        }
      }
    }
    return playlists10;
  } else {
    throw Exception('Failed to load playlist');
  }
}

class ListViewPosts extends StatelessWidget {
  List<Playlist> playlistsview = new List();

  ListViewPosts({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: playlistsview.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return new Container(
                  margin: const EdgeInsets.only(right: 0),
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {},
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                    image: NetworkImage(
                                        playlistsview[Index].ImageUrl),
                                    width: 110.0,
                                    height: 110,
                                    fit: BoxFit.fitHeight),
                              ]))));
            }));
  }
}

class ListViewVertical extends StatelessWidget {
  List<Playlist> playlistsview = new List();

  ListViewVertical({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 15),
        height: 260,
        alignment: Alignment.topCenter,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
            itemCount: playlistsview.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return new Container(
                  width: 400,
                  height: 60,
                  color: Colors.black87,
                  margin: const EdgeInsets.only(top: 3),
                  alignment: Alignment.topCenter,
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {},
                      borderSide: BorderSide(color: Colors.black),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                              children: <Widget>[
                                Image(
                                    image: NetworkImage(
                                        playlistsview[Index].ImageUrl),
                                    width: 60.0,
                                    height: 60.0,
                                    fit: BoxFit.fitHeight),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    playlistsview[Index].PlaylistName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ])))
                              );
             }
            ));
  }
}

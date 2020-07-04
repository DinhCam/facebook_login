import 'package:loginfacebook/model/media.dart';
class Playlist {
  final String Id;
  final String PlaylistName;
  final String ModifyBy;
  final String ModifyDate;
  final String CreateBy;
  final String CreateDate;
  final bool IsDelete;
  final int DateFillter;
  final int TimePlayed;
  final String ImageUrl;
  final String BrandName;
  List<Media> media = List<Media>();
  Playlist(
      {this.Id,
      this.PlaylistName,
      this.CreateBy,
      this.DateFillter,
      this.ImageUrl,
      this.IsDelete,
      this.ModifyBy,
      this.CreateDate,
      this.ModifyDate,
      this.TimePlayed,
      this.BrandName});
  factory Playlist.fromJson(Map<String, dynamic> json) {
    return new Playlist(
      Id: json['Id'],
      PlaylistName: json['PlaylistName'],
      CreateBy: json['CreateBy'],
      DateFillter: json['DateFillter'],
      ImageUrl: json['ImageUrl'],
      IsDelete: json['IsDelete'],
      ModifyBy: json['ModifyBy'],
      CreateDate: json['CreateDate'],
      ModifyDate: json['ModifyDate'],
      TimePlayed: json['TimePlayed'],
      BrandName: json['BrandName']
    );
  }
}
class Playlist {
  String Id;
  String PlaylistName;
  String ModifyBy;
  String ModifyDate;
  String CreateBy;
  String CreateDate;
  bool IsDelete;
  int DateFillter;
  int TimePlayed;
  String ImageUrl;
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
      this.TimePlayed});
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
    );
  }
}
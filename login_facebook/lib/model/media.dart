class Media {
  String Id;
  String MusicName;
  String ModifyBy;
  String ModifyDate;
  String CreateBy;
  String CreateDate;
  bool IsDelete;
  String Url;
  String ImageUrl;
  String Author;
  String Singer;
  int Type;
  // List Category;
//  List get getCategory => Category;

//  set setCategory(List Category) => this.Category = Category;
  String get getId => Id;

  set setId(String Id) => this.Id = Id;

  String get getMusicName => MusicName;

  set setMusicName(String MusicName) => this.MusicName = MusicName;

  String get getModifyBy => ModifyBy;

  set setModifyBy(String ModifyBy) => this.ModifyBy = ModifyBy;

  String get getModifyDate => ModifyDate;

  set setModifyDate(String ModifyDate) => this.ModifyDate = ModifyDate;

  String get getCreateBy => CreateBy;

  set setCreateBy(String CreateBy) => this.CreateBy = CreateBy;

  String get getCreateDate => CreateDate;

  set setCreateDate(String CreateDate) => this.CreateDate = CreateDate;

  bool get getIsDelete => IsDelete;

  set setIsDelete(bool IsDelete) => this.IsDelete = IsDelete;

  String get getUrl => Url;

  set setUrl(String Url) => this.Url = Url;

  String get getImageUrl => ImageUrl;

  set setImageUrl(String ImageUrl) => this.ImageUrl = ImageUrl;

  String get getAuthor => Author;

  set setAuthor(String Author) => this.Author = Author;

  String get getSinger => Singer;

  set setSinger(String Singer) => this.Singer = Singer;

  int get getType => Type;

  set setType(int Type) => this.Type = Type;
  Media(
      {
      this.Id,
      this.MusicName,
      this.CreateBy,
      this.ImageUrl,
      this.IsDelete,
      this.ModifyBy,
      this.CreateDate,
      this.ModifyDate,
      this.Author,
      this.Singer,
      this.Type,
      this.Url,
      // this.Category
      }
  );
  factory Media.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new Media(
        Id: json['Id'],
        MusicName: json['MusicName'],
        Url: json['Url'],
        CreateBy: json['CreateBy'],
        Author: json['Author'],
        ImageUrl: json['ImageUrl'],
        IsDelete: json['IsDelete'],
        ModifyBy: json['ModifyBy'],
        CreateDate: json['CreateDate'],
        ModifyDate: json['ModifyDate'],
        Singer: json['Singer'],
        Type: json['Type']);
        
  }
}

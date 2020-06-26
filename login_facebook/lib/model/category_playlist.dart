import 'package:loginfacebook/model/category.dart';

class CategoryPlaylist{
  String _id;
  String _playlistId;
  String _categoryId;
  List<CategoryObj> _listCategory;
 String get id => _id;

 set id(String value) => _id = value;

 String get playlistId => _playlistId;

 set playlistId(String value) => _playlistId = value;

 String get categoryId => _categoryId;

 set categoryId(String value) => _categoryId = value;

 List get listCategory => _listCategory;

 set listCategory(List value) => _listCategory = value;
 
 

 
 CategoryPlaylist(
   {
      String id,
      String playlistId,
      String categoryId,
      List<CategoryObj> listCategory,
   }
 ):_id=id,_playlistId=playlistId,_categoryId=categoryId,_listCategory=listCategory;
 factory CategoryPlaylist.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new CategoryPlaylist(
      id: json['Id'],
      playlistId: json['PlaylistId'],
      categoryId: json['CategoryId'],
      listCategory: parseCategory(json)
    );
        
  }
  static List<CategoryObj> parseCategory(jsonCategory){
    var list = jsonCategory['Category'] as List;
    List<CategoryObj> categoryList=
      list.map((e) => CategoryObj.fromJson(e)).toList();
      return categoryList;
  }
}
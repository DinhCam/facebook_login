import 'package:flutter/foundation.dart';
import 'package:loginfacebook/model/category.dart';

class CategoryMedia {
  String Id;
  String MediaId;
  String CategoryId;
  List<CategoryObj> listCategory;
  List get getListCategory => listCategory;

  set setListCategory(List listCategory) => this.listCategory = listCategory;
  String get getId => Id;

  set setId(String Id) => this.Id = Id;

  String get getMediaId => MediaId;

  set setMediaId(String MediaId) => this.MediaId = MediaId;

  String get getCategoryId => CategoryId;

  set setCategoryId(String CategoryId) => this.CategoryId = CategoryId;

  CategoryMedia({this.Id, this.MediaId, this.CategoryId, this.listCategory});
  factory CategoryMedia.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new CategoryMedia(
        Id: json['Id'],
        MediaId: json['MediaId'],
        CategoryId: json['CategoryId'],
        listCategory: parseCategory(json));
  }
  static List<CategoryObj> parseCategory(jsonCategory) {
    var list = jsonCategory['Category'] as List;
    List<CategoryObj> categoryList =
        list.map((e) => CategoryObj.fromJson(e)).toList();
    return categoryList;
  }
}

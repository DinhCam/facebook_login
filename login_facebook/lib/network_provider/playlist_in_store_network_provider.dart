import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loginfacebook/model/account.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/model/playlist_in_store.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/setting/setting.dart';

class PlaylistInStoreNetWorkProvider {
  String baseUrl =
      Setting.baseUrl+'PlaylistsInStores/';

  List<PlaylistInStore> listPlaylistInStore = new List();

  Future<List<PlaylistInStore>> getPlaylistInStoreByStoreId(String storeId,int sortType, bool isPaging, int pageNumber, int pageLimit) async {
    String url = baseUrl + storeId +"?SortType="+ sortType.toString()+"&IsPaging="+ isPaging.toString() +"&PageNumber="+ pageNumber.toString()+"&PageLimitItem="+ pageLimit.toString();
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + currentUserWithToken.Token
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      listPlaylistInStore = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            listPlaylistInStore.add(PlaylistInStore.fromJson(map));
          }
        }
      }
      return listPlaylistInStore;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Future<String> putPlaylistInStoreByStoreId(UserAuthenticated user, List<Playlist> list, String storeID) async{
    String jsonString = '{' +
        '"userID": "' + user.Id + '",'
         +
        '"list": [' 
          +
          await getString(list)
          +
        '],' +
        '"isVip": ' + user.IsVip.toString() + ','+
        '"storeId": "' + storeID + '"'
        '}';
        final http.Response response =await http.put(baseUrl, headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        }, body: jsonString);
        if(response.statusCode == 200){
          return "Success";
        }else if(response.statusCode == 400){
          return "fail";
        } else{
          return response.body.toString();
        }
  }
  getString(List<Playlist> list) async{
    String a="";
    list.forEach((e) {
      a+='"'+e.Id+'",';
    });
    return a.substring(0,a.length-1);
  }

  
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/setting/setting.dart';

class MediaNetWorkProvider {
  String baseUrl =
      Setting.baseUrl+'Media/';

  List<Media> listMedia = new List();

  Future<List<Media>> getMediaByplaylistId(String playlistId,int sortType, bool isPaging, int pageNumber, int pageLimit, int typeMedia ) async {
    String url = baseUrl + playlistId +"?SortType="+ sortType.toString()+"&IsPaging="+ isPaging.toString() +"&PageNumber="+pageNumber.toString()+"&PageLimitItem="+pageLimit.toString()+"&Type="+ typeMedia.toString();
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + currentUserWithToken.Token
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      listMedia = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            listMedia.add(Media.fromJson(map));
          }
        }
      }
      return listMedia;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  
}

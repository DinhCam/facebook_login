import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loginfacebook/model/current_media.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/setting/setting.dart';

class CurrentMediaNetWorkProvider {
  String baseUrl =
      Setting.baseUrl+'CurrentMedia/';

  List<CurrentMedia> listCurrentMedia = new List();

  Future<List<CurrentMedia>> getCurrentMediabyStoreId(String storeId) async {
    String url = baseUrl + storeId ;
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + currentUserWithToken.Token
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      listCurrentMedia = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            listCurrentMedia.add(CurrentMedia.fromJson(map));
          }
        }
      }
      return listCurrentMedia;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  
}

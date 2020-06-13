import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';

class MediaNetWorkProvider {
  String baseUrl =
      'https://audiostreaming-dev-as.azurewebsites.net/api/Media/';

  List<Media> listMedia = new List();

  Future<List<Media>> getMediaByplaylistId(String playlistId) async {
    String url = baseUrl + playlistId;
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

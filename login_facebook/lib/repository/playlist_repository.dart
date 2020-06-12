
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/network_provider/playlist_network_provider.dart';



class PlaylistRepository {
  PlayListNetWorkProvider playListNetWorkProvider = PlayListNetWorkProvider();

  Future<List<Playlist>> getUserFavoritesPlaylist() async{
   return await playListNetWorkProvider.getUserFavoritePlaylists();
  }
  Future<List<Playlist>> getTop3Playlists() async{
   return await playListNetWorkProvider.getTop3Playlists();
  }
  Future<List<Playlist>> getPlaylists(int page) async{
   return await playListNetWorkProvider.getPlaylists(page);
  }
}
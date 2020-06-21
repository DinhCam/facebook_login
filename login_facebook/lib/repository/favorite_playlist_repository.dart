import 'package:loginfacebook/network_provider/favorite_playlist_network_provider.dart';

class FavoritePlaylistRepository{
  FavoritePlaylistNetWorkProvider favoritePlaylistNetworkProvider = FavoritePlaylistNetWorkProvider();

  Future<bool> addFavoritePlaylist(String playlistId, String accountId) async{
    return await favoritePlaylistNetworkProvider.addFavoritePlaylist(playlistId, accountId);
  }
  Future<bool> deleteFavoritePlaylist(String playlistId, String accountId) async{
    return await favoritePlaylistNetworkProvider.deleteFavoritePlaylist(playlistId, accountId);
  }
}
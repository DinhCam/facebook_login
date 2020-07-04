import 'package:loginfacebook/model/account.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/model/playlist_in_store.dart';
import 'package:loginfacebook/network_provider/playlist_in_store_network_provider.dart';

class PlaylistInStoreRepository {
  PlaylistInStoreNetWorkProvider playlistInStoreNetWorkProvider = PlaylistInStoreNetWorkProvider();

  Future<List<PlaylistInStore>> getPlaylistInStoreByStoreId(String storeId,int sortType, bool isPaging, int pageNumber, int pageLimit) async{
   return await playlistInStoreNetWorkProvider.getPlaylistInStoreByStoreId(storeId, sortType, isPaging, pageNumber, pageLimit);
  }

  Future<String> putPlaylistInStoreByStoreId(UserAuthenticated user, List<Playlist> list, String storeID) async{
    return await playlistInStoreNetWorkProvider.putPlaylistInStoreByStoreId(user, list, storeID);
  }
  
}

import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/network_provider/media_network_provider.dart';



class MediaRepository {
  MediaNetWorkProvider mediaNetWorkProvider = MediaNetWorkProvider();

  Future<List<Media>> getMediaByplaylistId(String playlistId, bool isSort, bool isDesending, bool isPaging, int pageNumber, int pageLimit, int typeMedia ) async{
   return await mediaNetWorkProvider.getMediaByplaylistId(playlistId, isSort, isDesending, isPaging, pageNumber, pageLimit, typeMedia );
  }
  
}
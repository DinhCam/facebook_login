
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/network_provider/store_network_provider.dart';

class StoresRepository {
  StoresNetWorkProvider storesNetWorkProvider = StoresNetWorkProvider();

  Future<Store> getMediaByplaylistId(String storeId) async{
   return await storesNetWorkProvider.getStoreById(storeId);
  }
  
}
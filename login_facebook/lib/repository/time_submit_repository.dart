
import 'package:loginfacebook/model/time_submit.dart';
import 'package:loginfacebook/network_provider/time_submit_network_provider.dart';

class TimeSubmitRepository {
  TimeSubmitNetworkProvider _timeSubmitNetworkProvider = TimeSubmitNetworkProvider();

  Future<TimeSubmit> getTimeSubmitByUserID(String userID,String storeID) async{
   return await _timeSubmitNetworkProvider.getTimeSubmitByUserID(userID,storeID);
  }
  
}
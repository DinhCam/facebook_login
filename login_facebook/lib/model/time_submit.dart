class TimeSubmit{
  String _id;
  String _userId;
  DateTime _timeSubmit;
  String _storeId;
 String get id => _id;

 set id(String value) => _id = value;

 String get userId => _userId;

 set userId(String value) => _userId = value;

 String get storeId => _storeId;

 set storeId(String value) => _storeId = value;
 DateTime get timeSubmit => _timeSubmit;
 set timeSubmit(DateTime value) => _timeSubmit= value;
TimeSubmit({
  String id,
  String userID,
  DateTime timeSubmit,
  String storeId
}) : _id=id,_userId=userID,_timeSubmit=timeSubmit,_storeId=storeId;

factory TimeSubmit.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new TimeSubmit(
        id: json['Id'],
        userID: json['UserId'],
        timeSubmit: DateTime.parse(json['TimeSubmit1']),
        storeId: json['StoreId']
        );
  }
}
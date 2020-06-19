

class CategoryObj{
  String Id;
  String Name;
 String get getId => Id;

 set setId(String Id) => this.Id = Id;

 String get getName => Name;

 set setName(String Name) => this.Name = Name;
 
 CategoryObj(
   {
     this.Id,
     this.Name
   }
 );
 factory CategoryObj.fromJson(Map<String, dynamic> json) {
    // List listCateName= json['']
    return new CategoryObj(
        Id: json['Id'],
        Name: json['CategoryName']);        
  }
}

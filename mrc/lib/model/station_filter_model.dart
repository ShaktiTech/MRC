class StationFilterModel{
  
 late String name;
 late String flags;
 late bool isSelected;
  List<StationFilterModel>subList =[];
   StationFilterModel(this.name,this.flags, this.isSelected,this.subList,);

  StationFilterModel.fromJson(Map<String, dynamic> json) {
     name = json['name'];
     flags = json['flags'];
     isSelected =json['isSelected'];
     if(json['subList']!= null)
     {
      subList.clear();
      json['subList'].forEach((v){
        subList.add(StationFilterModel.fromJson(v));
      });

     }
  }
}

class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title,this._date, this._priority, [this._description]);
  Note.withID(this._id, this._title, this._date, this._priority, [this._description]);

  int get id=> _id;
  String get title=> _title;
  String get description => _description;
  int get priority=> _priority;
  String get date=> _date;

  set title( String newTitle){
    if(newTitle.length<=255){
      this._title=newTitle;
    }
  }
  set description ( String newDescription){
    if(newDescription.length<=255){
      this._description=newDescription;
    }
  }
  set priority( int newPriority){
    if(newPriority>=1 && newPriority<=2){
      this._priority=newPriority;
    }
  }
  set date(String newDate){
    this._date=newDate;
  }
  Map<String, dynamic> toMap(){
    print('hihhhhhhhhhhh');
    var map = Map<String,dynamic>();
    if(id!=null){
      map['_id']=id;
    }
    map['description']=description;
    map['priority']=priority;
    map['title']=title;
    map['date']=date;
    print("map");
    print(map);
    return map;
  }
  Note.fromMapObject(Map<String, dynamic>map){
    this._id=map['id'];
    this._title=map['title'];
    this._description=map['description'];
    this._priority=map['priority'];
    this._date=map['date'];

  }
}
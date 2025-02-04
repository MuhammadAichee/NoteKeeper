import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/model/note.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String noteTable='note_table';
  String colId ='id';
  String colTitle='title';
  String colDescription='description';
  String colPriority='priority';
  String colDate='date';
  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper=DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database==null){
      _database=await initializeDatabase();
    }
    print('Hassans Check');
    print(_database);
    
    return _database;
  }
  Future<List<Map<String,dynamic>>> getNoteMapList() async{
    Database db= await this.database;
//    var result=await db.rawQuery('SELECT * FROM $noteTable order by colPriority ASC');
    var result= await db.query(noteTable, orderBy:  '$colPriority ASC');
    return result;
  }
  Future<int>insertNote(Note note) async{
    Database db= await this.database;
    print("yesssssssssss");
    print(note.description);
    print("Notetable");
    print(noteTable);
    var result= await db.insert(noteTable, note.toMap());
    print ('im');
    print(result);
    return result;
  }
  Future<int>updateNote(Note note) async{
    var db= await this.database;
    var result= await db.update(noteTable, note.toMap(),where:'$colId = ?' , whereArgs: [note.id]);
    return result;
  }
  Future<int>deleteNote(int id) async{
    Database db= await this.database;
    var result= await db.rawDelete('DELETE FROM $noteTable Where $colId = $id');
    return result;
  }
  Future<int>getCount() async{
    var db= await this.database;
    List<Map<String,dynamic>> x =await db.rawQuery('SELECT COUNT(*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
  Future<List<Note>> getNoteList() async{
    var noteMapList= await getNoteMapList();
    int count =noteMapList.length;
    List<Note> noteList=List<Note>();
    for ( int i=0;i<count;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
  Future<Database>initializeDatabase() async{
  Directory directory= await getApplicationDocumentsDirectory();
  String path= directory.path +'notes.db';
  print("path");
  print(path);

  var notesDatabase=await openDatabase(path, version:1,onCreate: _createDb );
  print(notesDatabase);

  
  return notesDatabase;
  }
  void _createDb(Database db, int newVersion) async{
    String creation = "CREATE TABLE $noteTable ("
       "$colId INTEGER PRIMARY KEY AUTOINCREMENT,"
       "$colTitle TEXT,"
       "$colDescription TEXT,"
       "$colPriority INTEGER ,"
       "$colDate TEXT"
       ")";
     return await db.execute(creation);


  }

}
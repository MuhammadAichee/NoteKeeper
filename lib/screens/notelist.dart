import 'package:flutter/material.dart';
import 'package:notekeeper/screens/notedetail.dart';
import 'package:notekeeper/model/note.dart';

import 'package:intl/intl.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }

}
class NoteListState extends State<NoteList>{
  DatabaseHelper databaseHelper= DatabaseHelper();
  List<Note> noteList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Notes'),

      ),
      body: getNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('fab pressed');
          getNavigate(Note('','',2),'Add Note');
          },

        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }
  ListView getNoteList(){
    TextStyle titlestyle=Theme.of(context).textTheme.subhead;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Card(
           color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),

              ),
                title: Text(this.noteList[position].title,style: titlestyle ?? 'No Title'),
                subtitle: Text(this.noteList[position].date,style: titlestyle),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey,),
                  onTap:(){
                    _delete(context, noteList[position]);
                  },
                ),

                onTap:(){
                debugPrint("ListTile Tapped");
                  getNavigate(this.noteList[position],'Edit Note');
               }
            )

          );
    },
    );
  }
  void updateListView(){
    final Future<Database> dbFuture= databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.blue;
        break;
      default:
        return Colors.blue;


    }
  }
  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);


    }
  }
  void _delete(BuildContext context,Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if (result!=0){
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }
  void _showSnackBar(BuildContext context, String message){
    final snackBar= SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  getNavigate(Note note, String text) async{
   bool result=await Navigator.push(context, MaterialPageRoute(builder: (context){
    return NoteDetails(note,text);
  })
  );
   if(result=true)
     {
       updateListView();
     }
}
}

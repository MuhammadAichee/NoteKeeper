import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:notekeeper/model/note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetails extends StatefulWidget{
  final String appBarTitle;
  final Note note;
  NoteDetails(this.note,this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NoteDetailsState(this.note,this.appBarTitle);
  }

}
class _NoteDetailsState extends State<NoteDetails>{
  static var _priorities=["High","Low"];
  var value="Low";
  DatabaseHelper helper=DatabaseHelper();
  String appBarTitle;
  Note note;
  TextEditingController titleController =  TextEditingController();
  TextEditingController descriptionController =  TextEditingController();
  _NoteDetailsState(this.note,this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =Theme.of(context).textTheme.title;
    titleController.text=note.title;
    descriptionController.text=note.description;
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        title:Text(this.appBarTitle),
    ),
      body:Padding(
          padding: EdgeInsets.only(
            top: 15.0, left: 10.0, right: 10.0
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem){
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style:textStyle,
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser){
                    setState(() {
                      debugPrint('User Selected $valueSelectedByUser');
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  },
                )
              ),
              Container(
                height:80.0,
              child:Padding(
                padding: EdgeInsets.only(top:15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style:textStyle,
                  onChanged: (value){
                    updateTitle();
                    debugPrint("Something chamges in title text field");
                  },
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),

                    )
                  ),
                )
              ),),
              Container(
                height:80.0,
    child:
              Padding(
                  padding: EdgeInsets.only(top:15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style:textStyle,
                    onChanged: (value){
                      debugPrint("Something chamges in Description text field");
                        updateDescription();
                      },
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),

                        )
                    ),
                  )
              ),),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom:15.0),
                child: Row(
                   children: <Widget>[
                     Expanded(child: RaisedButton(
                         color: Theme.of(context).primaryColorDark,
                         textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Save",
                          textScaleFactor: 1.5,
                        ),
                       onPressed: (){
                           setState(() {
                             debugPrint("Save button pressed");
                             _save();
                           });

                       },
                     )),
                      Container(
                        width:5.0
                      ),
                     Expanded(child: RaisedButton(
                       color: Theme.of(context).primaryColorDark,
                       textColor: Theme.of(context).primaryColorLight,
                       child: Text(
                            "Delete",
                           textScaleFactor: 1.5,
                       ),
                       onPressed: (){
                         setState(() {
                           debugPrint("Delete button pressed");
                           _delete();
                         });

                       },

                     ))
                   ],
                )
              )
            ],
          )
      )

    );
  }
  void updateTitle(){
    note.title=titleController.text;
  }
  void updateDescription(){
    note.description=descriptionController.text;
  }
  void updatePriorityAsInt(String value){
    switch (value){
      case 'High':
        note.priority=1;
        break;
      case 'low':
        note.priority=2;
        break;
    }

  }
  String getPriorityAsString(int value){
    String priority;
    switch (value){
      case 1:
        priority=_priorities[0];
        break;
      case 2:
        priority=_priorities[1];
        break;
    }
    return priority;
  }
  void _delete() async{
    movetoLastScreen();
    if(note.id==null){
      _showAlterDialog('Status', 'No Note Was Deleted');
    }
    int result = await helper.deleteNote(note.id);
    if(result!=0){
      _showAlterDialog('Status','Note Deleted Successfully');
    }
    else{
      _showAlterDialog('Status','error Occured');
    }
  }
  void _save() async{
    movetoLastScreen();
    note.date=DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id !=null){
      _showAlterDialog('Status','Ahsan');
      result = await helper.updateNote(note);
      print(note);
      print ("iske uper note ka result");
      print(result);
      _showAlterDialog('Status','Ahsan1');
    }
    else
      {
      _showAlterDialog('Status','Ahsan insert');
      result = await helper.insertNote(note);
      print(note);
      print ("iske uper note ka result");
      _showAlterDialog('Status','Ahsan2');
    }
    if (result!=0){
      _showAlterDialog('Status','Note Saved Successfully');
    }
    else{
      _showAlterDialog('Status','Problem Saving Note');
    }
}
  void _showAlterDialog(String title, String Message){
    AlertDialog alertDialog=new AlertDialog(
      title:Text(title),
      content:Text(Message),
    );
    showDialog(
      context:context,
      builder:  (_)=>alertDialog
    );
  }
  void movetoLastScreen(){
    Navigator.pop(context,true);
  }
}
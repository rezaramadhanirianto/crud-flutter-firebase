import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _dueDate = new DateTime.now();
  String _dateText = "";
  String newTask = "";
  String note = "";  
  

  Future<Null> _selectDueDate(BuildContext context) async{
    final picked = await showDatePicker(context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2019), 
      lastDate: DateTime(2080)
    );

    if(picked != null){
      setState(() {
        _dueDate=picked; 
        _dateText="${picked.day}/${picked.month}/${picked.year}";
      });
    }

  }
    void _addData() async {
      DocumentReference ref = await Firestore.instance.collection("task")
      .add({
            "email" : widget.email,
          "title" : newTask,
          "duedate": _dueDate,
          "note" : note,
      });
  // print(ref.documentID);
      Navigator.pop(context);
    }

    @override
  void initState() {
    _dateText="${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("img/hero-banner.png"),fit: BoxFit.cover
              ),
              color: Colors.purple
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text("My Task", 
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  letterSpacing: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("ADD TASK", style: new TextStyle(fontSize: 24, color: Colors.white),),
              ),
              Icon(Icons.list, color: Colors.white, size: 30,),
            ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  newTask = str; 
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.dashboard),
                hintText: "New Task",
                border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: new Icon(Icons.date_range),
                ),

                new Expanded(
                  child: Text("Due Date", style: new TextStyle(fontSize: 22, color: Colors.black),),
                ),
                new FlatButton(
                  onPressed: (){
                    _selectDueDate(context);
                  },
                  child: Text(_dateText, style: new TextStyle(fontSize: 22, color: Colors.black),)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  note = str; 
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.note),
                hintText: "Note",
                border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              IconButton(
                icon: Icon(Icons.check, size: 40,),
                onPressed: ()=>_addData(),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 40,),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],),
          )
        ],
      ),
    );
  }
}
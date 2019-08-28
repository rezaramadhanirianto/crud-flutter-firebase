import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditData extends StatefulWidget {
  EditData({this.title, this.duedate, this.note, this.index});
  final String title;
  final String note;
  final DateTime duedate;
  final index;
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {

  TextEditingController controllerTitle;
  TextEditingController controllerNote;

  DateTime _dueDate;
  String _dateText = "";
  String newTask = "";
  String note = "";  
  
  void _update(){
    // Firestore.instance.runTransaction((Transaction transaction) async{
    //   DocumentSnapshot documentSnapshot = await transaction.get(widget.index);
    //   await transaction.get(widget.index);
    //   await transaction.update(documentSnapshot.reference, {
    //     "title" : newTask,
    //     "note" : note,
    //     "duedate" : _dueDate,
    //   });
    // });
    try {
    Firestore.instance
        .collection('task')
        .document(widget.index)
        .updateData({
          "title" : newTask,
          "note" : note,
          "duedate" : _dueDate,
        });
    } catch (e) {
      print(e.toString());
    }
    Navigator.pop(context);
  }


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

    @override
  void initState() {
    super.initState();
    _dueDate = widget.duedate;
    _dateText="${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    newTask = widget.title;
    note  = widget.note;
    controllerTitle = new TextEditingController(text: widget.title);
    controllerNote = new TextEditingController(text: widget.note);
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
                child: Text("Edit TASK", style: new TextStyle(fontSize: 24, color: Colors.white),),
              ),
              Icon(Icons.list, color: Colors.white, size: 30,),
            ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerTitle,
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
              controller: controllerNote,
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
                onPressed: (){
                  _update();
                },
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
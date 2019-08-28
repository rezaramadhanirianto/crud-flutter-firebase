import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'addTask.dart';
import 'main.dart';
import 'editData.dart';
import 'dart:async';

class MyTask extends StatefulWidget {
  MyTask({this.user, this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {

  void _signOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 250,
        child: Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(widget.user.photoUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Sign Out ? ",
                style: new TextStyle(fontSize: 16),
              ),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new MyHomePage()),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(padding: const EdgeInsets.all(5)),
                      new Text("Yes")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(padding: const EdgeInsets.all(5)),
                      new Text("Cancel")
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    showDialog(context: context, child: alertDialog);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new AddTask(
              email: widget.user.email,
            ),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
          elevation: 20,
          color: Colors.purple[300],
          child: ButtonBar(
            children: <Widget>[],
          )
        ),
      body: new Stack(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
                .collection("task")
                .where("email", isEqualTo: widget.user.email)
                .snapshots(),

              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData)
                return new Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                return new TaskList(document: snapshot.data.documents,);
              }
            ),
          ),

          Container(
            height: 170.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage("img/hero-vector-overlay.png"),
                    fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 8.0),
                ],
                color: Colors.purple),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: new NetworkImage(widget.user.photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Welcome",
                                style: new TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              new Text(
                                widget.user.displayName,
                                style: new TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          _signOut();
                        },
                      )
                    ],
                  ),
                ),
                new Text("My Task",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      letterSpacing: 2,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String title = document[i].data['title'].toString();
        String note = document[i].data['note'].toString();
        DateTime _date = document[i].data['duedate'];
        String duedate = "${_date.day}/${_date.month}/${_date.year}";
        
        return new Dismissible(
          key: new Key(document[i].documentID),
          onDismissed: (direction){
            Firestore.instance.collection("task")
              .document(document[i].documentID)
              .delete();
              Scaffold.of(context).showSnackBar(
                new SnackBar(content: Text("Data Deleted"))
              );
          },
                  child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                                child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(title, style: new TextStyle(fontSize: 20, letterSpacing: 1),),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.data_usage, color: Colors.purple),
                            ),
                            Text(duedate, style: new TextStyle(fontSize: 18, letterSpacing: 1),),
                          ],
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.note, color: Colors.purple,),
                            ),
                            new Expanded(child: Text(note, style: new TextStyle(fontSize: 18, letterSpacing: 1),)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                new IconButton(
                  icon: Icon(Icons.edit, color: Colors.purple),
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context)=> new EditData(
                          title: title,
                          duedate: document[i].data['duedate'],
                          note: note,
                          index: document[i].documentID
                        ),
                      )
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
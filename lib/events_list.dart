import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database_tutorial/events_edit.dart';

class Home_events extends StatefulWidget {
  Home_events({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home_events> {
  final dbRef = FirebaseDatabase.instance.reference().child("pets");
  final events = FirebaseFirestore.instance.collection("events");

  List<Map<dynamic, dynamic>> lists = [];
  List<String> listid = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<QuerySnapshot>(
             future: events.get().then((querySnapshot) {
               querySnapshot.docs.forEach((result) {

               }
               );
               return querySnapshot;

             }),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                listid.clear();
                final List<DocumentSnapshot> values = snapshot.data.docs;
                values.asMap().forEach((key, values) {
                  lists.add(values.data());
                  listid.add(values.id);
                });
                 return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                       return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("ID: " + listid[index]),
                            Text("Тип: " + lists[index]["type"]),
                            Text("Подтип: " + lists[index]["subtype"]),
                            Text("Название: " + lists[index]["name"]),
                            ElevatedButton(onPressed:  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Event_edit(nomer: index.toString(), name: lists[index]["name"], type: lists[index]["type"], subtype: lists[index]["subtype"], title: "Редактирование")),
                              );
                            },
                                child: Text('Изменить'))
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}

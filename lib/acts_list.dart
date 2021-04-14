import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database_tutorial/acts_edit.dart';

class HomeActs extends StatefulWidget {
  HomeActs({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  _HomeActs createState() => _HomeActs();
}

class _HomeActs extends State<HomeActs> {
  final events = FirebaseFirestore.instance.collection("acts");

  List<Map<dynamic, dynamic>> lists = [];
  List<String> listId = [];

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
                listId.clear();
                final List<DocumentSnapshot> values = snapshot.data.docs;
                values.asMap().forEach((key, values) {
                  lists.add(values.data());
                  listId.add(values.id);
                });
                 return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                       return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("ID: " + listId[index]),
                            Text("Тип: " + lists[index]["type"]),
                            Text("Событие: " + lists[index]["event"]),
                            Text("Название: " + lists[index]["name"]),
                            Text("Описание: " + lists[index]["description"]),
                            ElevatedButton(onPressed:  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActEdit(nom: index.toString(), name: lists[index]["name"], type: lists[index]["type"], event: lists[index]["event"], description: lists[index]["description"], title: "Редактирование")),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/Edit/event_edit.dart';

class ListEvents extends StatefulWidget {
  ListEvents({Key key, this.title}) : super(key: key);
  final dynamic title;

  @override
  _ListEvents createState() => _ListEvents();
}

class _ListEvents extends State<ListEvents> {
  final events = FirebaseFirestore.instance.collection("events");

  List<Map<dynamic, dynamic>> lists = [];
  List<String> listId = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference events = FirebaseFirestore.instance.collection("events");
    var _ev;

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
                            Text("Подтип: " + lists[index]["subtype"]),
                            Text("Название: " + lists[index]["name"]),
                            snapshot.data.docs[index]["url"]!=null ? Image.network(snapshot.data.docs[index]["url"]):Text('Нет картинки'),
                            ElevatedButton(onPressed:  () async {


                             _ev = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventEdit1(nom: index.toString(), url: snapshot.data.docs[index]["url"], id: listId[index] ,name: lists[index]["name"], type: lists[index]["type"], subtype: lists[index]["subtype"], title: "Редактирование")),
                              );
                              setState(() {

                              });
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

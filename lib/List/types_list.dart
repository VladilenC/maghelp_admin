import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Edit/type_edit.dart';

class ListTypes extends StatefulWidget {
  ListTypes({Key key, this.title}) : super(key: key);
  final dynamic title;

  @override
  _ListTypes createState() => _ListTypes();
}

class _ListTypes extends State<ListTypes> {
  final types = FirebaseFirestore.instance.collection("types");

  List<Map<dynamic, dynamic>> lists = [];
  List<String> listId = [];

  @override
  Widget build(BuildContext context) {
  //  CollectionReference events = FirebaseFirestore.instance.collection("events");
    var _ev, _et;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<QuerySnapshot>(
             future: types.get().then((querySnapshot) {
               querySnapshot.docs.forEach((result) {
//_et = result.id;
//types.doc(_et).update({'name': _et, 'description': '', 'url': '' }) ;
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
     //                       Text("ID: " + listId[index]),
                            Text("название: " + lists[index]["name"]),
                            Text("Описание: " + lists[index]["description"]),
                            snapshot.data.docs[index]["url"]!=null ? Image.network(snapshot.data.docs[index]["url"]):Text('Нет картинки'),
                            ElevatedButton(onPressed:  () async {


                             _ev = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TypeEdit1(nom: index.toString(), url: snapshot.data.docs[index]["url"], id: listId[index] ,name: lists[index]["name"], description: lists[index]["description"], title: "Редактирование")),
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

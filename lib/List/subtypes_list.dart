import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Edit/subtype_edit.dart';

class ListSubtypes extends StatefulWidget {
  ListSubtypes({Key key, this.title, this.type}) : super(key: key);
  final dynamic title,type;

  @override
  _ListSubtypes createState() => _ListSubtypes();
}

class _ListSubtypes extends State<ListSubtypes> {
  final types = FirebaseFirestore.instance.collection("types");
  final coltypes = FirebaseFirestore.instance.collection("types").doc().collection('subs');

  final subtypes = FirebaseFirestore.instance.collection("subtypes");
  List<Map<dynamic, dynamic>> lists = [];
  List<String> listId = [];

  @override
  Widget build(BuildContext context) {
  //  CollectionReference events = FirebaseFirestore.instance.collection("events");
    var _ev, _et, _ec,et;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<QuerySnapshot>(
             future: subtypes.where('typeid',isEqualTo: widget.type).get().then((querySnapshot) {
               querySnapshot.docs.forEach((result) {


//_et = result.id;
//et = result.id;
//var  _qq = coltypes;
//FutureBuilder<QuerySnapshot>(
//  future: types.doc(et).collection('subs').get().then((col) {
//    et = result.id;
//  col.docs.forEach((element) {
//    _ec = element.id;
//    print(_ec);
//    print(et);
//    print('-----------');
//    subtypes.doc(_ec).update({'name': _ec, 'description' : '', 'typeid': et, 'url': ''});
//  });
//  return col;
//  },
//),
//builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//    return Text('Сделано');
//                 },
//);

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
                            Text("Название: " + lists[index]["name"]),
                            Text('Тип:'  + lists[index]['typeid']),
                            Text("Описание: " + lists[index]["description"]),
                            snapshot.data.docs[index]["url"]!=null ? Image.network(snapshot.data.docs[index]["url"]):Text('Нет картинки'),
                            ElevatedButton(onPressed:  () async {


                             _ev = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubEdit1(nom: index.toString(), url: snapshot.data.docs[index]["url"], id: listId[index] ,name: lists[index]["name"], description: lists[index]["description"], title: "Редактирование")),
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

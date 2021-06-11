import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/Edit/act_edit.dart';
import 'package:maghelp_add_act/List/accessories_list.dart';

class ListActs extends StatefulWidget {
  ListActs({Key key,  this.title, this.event}) : super(key: key);
  final String title;
  final String event;

  @override
  _ListActs createState() => _ListActs();
}

class _ListActs extends State<ListActs> {
  final acts = FirebaseFirestore.instance.collection("acts");
  final events = FirebaseFirestore.instance.collection("events");

  CollectionReference  acts1 = FirebaseFirestore.instance.collection("acts");
  List<Map<dynamic, dynamic>> lists = [];
  List<dynamic> listId = [];

  @override
  Widget build(BuildContext context) {
    var _ac;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<QuerySnapshot>(


            future: acts.where("event", isEqualTo: widget.event).get().then((querySnapshot) {

              querySnapshot.docs.forEach((result) {

                //                var i1 = result.id;
                //                acts.doc(i1).update({'name': '1','url': '', 'description2': '', 'url2': '', 'description3': '', 'url3': ''});
//                  acts.doc(i1).collection('accessory').add({'name': '1','url': ''});
                //               var i2 = result.id;
                //               acts.doc(i1).collection("accessory").get().then((value) {
                //                value.docs.forEach((element) {
                //                    print(element.id);
                //                    var i2 = element.id;

                //                    acts.doc(i1).collection('accessory').doc(i2).delete();
                //                 });
                //               });
              }
              );

              return querySnapshot;
            }),


            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
      //          acts.doc().set({'name': '2'});
                lists.clear();
                listId.clear();
                final List<DocumentSnapshot> values = snapshot.data.docs;

                values.asMap().forEach((key, values) {
         //         acts.doc().update({'name': '3'});
                  lists.add(values.data());
                  listId.add(values.id);
                });
                 return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context,  index) {
                      snapshot.data.docs[index];
                       return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("ID: " + listId[index]),
                            Text("Тип: " + lists[index]["type"]),
                            Text("Событие: " + lists[index]["event"]),
                            Text("Название: " + lists[index]["name"]),
                            Text("Описание: " + lists[index]["description"] != null ? lists[index]["description"]:null),
                            snapshot.data.docs[index]["url"] != null ? Image.network(snapshot.data.docs[index]["url"]):null,
                            lists[index]["description2"] != null ? Text(lists[index]["description2"]):null,
                            snapshot.data.docs[index]["url2"] != null ? Image.network(snapshot.data.docs[index]["url2"]):null,
                            lists[index]["description3"] != null ? Text(lists[index]["description3"]):null,
                            snapshot.data.docs[index]["url3"] != null ? Image.network(snapshot.data.docs[index]["url3"]):null,

                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            ElevatedButton(onPressed:  () async {
                              _ac = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActEdit1(nom: index.toString(), id: listId[index], name: lists[index]["name"], type: lists[index]["type"], event: lists[index]["event"], description: lists[index]["description"], description2: lists[index]["description2"], description3: lists[index]["description3"], url: lists[index]["url"], url2: lists[index]["url2"], url3: lists[index]["url3"], title: "Редактирование")),
                              );
                              setState(() {

                              });
                            },
                                child: Text('Изменить')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                              onPressed: () async {

                                _ac = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListAccessories(title: "Аксессуары", id: listId[index], name: lists[index]["name"])),
                                );

  //                              Navigator.push(
 //                                 context,
//                                  MaterialPageRoute(
//                                      builder: (context) => ListActs(title: "Home Page")),
//                                );
                              },
                              child: Text('Аксессуары'),
                            )]),
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }
            )
    );
  }
}

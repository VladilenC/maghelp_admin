import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Edit/type_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListTypes extends StatefulWidget {
  ListTypes({Key? key, this.title}) : super(key: key);
  final dynamic title;

  @override
  _ListTypes createState() => _ListTypes();
}

class _ListTypes extends State<ListTypes> {
  final Stream<QuerySnapshot> types = FirebaseFirestore.instance
      .collection("types")
      .orderBy('name')
      .snapshots();
  var lists = [];
  List<String> listId = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: types,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                listId.clear();
                final List<DocumentSnapshot> values = snapshot.data!.docs;
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
                            Text("название: " + lists[index]["name"]),
                            Text("Описание: " + lists[index]["description"]),
                            snapshot.data!.docs[index]["url"] != null
                                ? CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]["url"],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                //               Image.network(snapshot.data!.docs[index]["url"])
                                : Text('Нет картинки'),
                            ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TypeEdit1(
                                            nom: index.toString(),
                                            url: snapshot.data!.docs[index]
                                                ["url"],
                                            id: listId[index],
                                            name: lists[index]["name"],
                                            description: lists[index]
                                                ["description"],
                                            title: "Редактирование")),
                                  );
                                  setState(() {});
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

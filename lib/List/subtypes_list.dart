import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Edit/subtype_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListSubtypes extends StatefulWidget {
  ListSubtypes({Key? key, this.title, this.type}) : super(key: key);
  final dynamic title, type;

  @override
  _ListSubtypes createState() => _ListSubtypes();
}

class _ListSubtypes extends State<ListSubtypes> {
  var lists = [];
  List<String> listId = [];
  final Stream<QuerySnapshot> subtypes = FirebaseFirestore.instance
      .collection("subtypes")
      .orderBy('name')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: subtypes,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                listId.clear();
                final values = widget.type != null
                    ? snapshot.data!.docs
                        .where((element) => element['typeid'] == widget.type)
                        .toList()
                    : snapshot.data!.docs.toList();

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
                            Text("Название: " + lists[index]["name"]),
                            Text('Тип:' + lists[index]['typeid']),
                            Text("Описание: " + lists[index]["description"]),
                            lists[index]["url"] != null
                                ? CachedNetworkImage(
                                    imageUrl: lists[index]["url"],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                //                Image.network(snapshot.data!.docs[index]["url"])
                                : Text('Нет картинки'),
                            ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubEdit1(
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

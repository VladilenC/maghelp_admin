import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/Edit/event_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListEvents extends StatefulWidget {
  ListEvents({Key? key, this.title, this.subtype}) : super(key: key);
  final dynamic title, subtype;

  @override
  _ListEvents createState() => _ListEvents();
}

class _ListEvents extends State<ListEvents> {
  var lists = [];
  List<String> listId = [];
  final Stream<QuerySnapshot> events = FirebaseFirestore.instance
      .collection("events")
      .orderBy('name')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: events,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                listId.clear();
                final values = widget.subtype != null
                    ? snapshot.data!.docs
                        .where(
                            (element) => element['subtype'] == widget.subtype)
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
                            Text("ID: " + listId[index]),
                            Text("Тип: " + lists[index]["type"]),
                            Text("Подтип: " + lists[index]["subtype"]),
                            Text("Название: " + lists[index]["name"]),
                            lists[index]["url"] != null
                                ? CachedNetworkImage(
                                    imageUrl: lists[index]["url"],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                //                    Image.network(snapshot.data!.docs[index]["url"])
                                : Text('Нет картинки'),
                            ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventEdit1(
                                            nom: index.toString(),
                                            url: lists[index]["url"],
                                            id: listId[index],
                                            name: lists[index]["name"],
                                            type: lists[index]["type"],
                                            subtype: lists[index]["subtype"],
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Edit/accessory_edit.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListAccessories extends StatefulWidget {
  ListAccessories({Key? key, this.title, this.accessories}) : super(key: key);
  final dynamic title, accessories;

  @override
  _ListAccessories createState() => _ListAccessories();
}

class _ListAccessories extends State<ListAccessories> {
  /*
  final Stream<QuerySnapshot> accessories = FirebaseFirestore.instance
      .collection("accessories")
      .orderBy('name')
      .snapshots();
      */
  var lists = [];
  List<String> listId = [];
  String textSearch = '';
  var searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Аксессуары: ' + textSearch),
        actions: [searchBar.getSearchAction(context)]);
  }

  _ListAccessories() {
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (text) {
          setState(() {
            textSearch = text;
          });
        },
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        body: StreamBuilder<QuerySnapshot>(
            stream: widget.accessories,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                listId.clear();
                final List<DocumentSnapshot> values = snapshot.data!.docs;
                if (textSearch == '') {
                  values.asMap().forEach((key, values) {
                    lists.add(values.data());
                    listId.add(values.id);
                  });
                } else {
                  values.asMap().forEach((key, values) {
                    if (values['name']
                        .toString()
                        .toLowerCase()
                        .contains(textSearch)) {
                      lists.add(values.data());
                      listId.add(values.id);
                    }
                  });
                }

                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(lists[index]["name"]),
                        leading: lists[index]["url"] != null
                            ? CachedNetworkImage(
                                imageUrl: lists[index]["url"],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            //                      Image.network(lists[index]["url"])
                            : null,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccessoryEdit1(
                                    nom: index.toString(),
                                    url: lists[index]["url"],
                                    id: listId[index],
                                    name: lists[index]["name"],
                                    title: "Редактирование")),
                          );
                          setState(() {});
                        },
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}

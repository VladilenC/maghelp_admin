import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/Utils/helpers.dart';

class ListAccessoriesAdd extends StatefulWidget {
  ListAccessoriesAdd({Key? key, this.title, this.id, this.accessories})
      : super(key: key);
  final dynamic title;
  final id, accessories;

  @override
  _ListAccessoriesAdd createState() => _ListAccessoriesAdd();
}

class _ListAccessoriesAdd extends State<ListAccessoriesAdd> {
  final acts = FirebaseFirestore.instance.collection("acts");
  /*
  final Stream<QuerySnapshot> accessories = FirebaseFirestore.instance
      .collection("accessories")
      .orderBy('name')
      .snapshots();
      */
  var lists = [];
  List<String> listId = [];
  int _selectedIndex = -1;
  String textSearch = '';
  var searchBar, xxx;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Аксессуары: ' + textSearch),
        actions: [searchBar.getSearchAction(context)]);
  }

  _ListAccessoriesAdd() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (text) {
          if (mounted) {
            setState(() {
              textSearch = text;
            });
          }
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
                  values.asMap().forEach((key, values) async {
                    lists.add(values.data());
                    listId.add(values.id);
                  });
                } else {
                  values.asMap().forEach((key, values) async {
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
                                errorWidget: (context, url, error) {
                                  return Icon(Icons.error);
                                })
                            //                  Image.network(lists[index]["url"])
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            putImage(index);
                          });
                        },
                        selected: index == _selectedIndex,
                        selectedTileColor: Colors.lightBlueAccent,
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }

  putImage(ind) {
    if (widget.id != null) {
      acts.doc(widget.id).collection('accessory').add({
        "url": lists[ind]["url"],
        "name": lists[ind]["name"],
        "accId": listId[ind]
      }).then((_) async {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Сохранено')));
        dynamic _count = await accessoryValue(widget.id);
        await acts.doc(widget.id).update({'accessories': _count});
      }).catchError((onError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(onError)));
      });
    }
    Navigator.pop(
        context, {"url": lists[ind]["url"], "name": lists[ind]["name"]});
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'accessory_list_add.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/Utils/helpers.dart';

class ListAccessoriesAct extends StatefulWidget {
  ListAccessoriesAct(
      {Key? key, this.title, this.id, this.name, this.accessories})
      : super(key: key);
  final dynamic title;
  final dynamic id;
  final dynamic name, accessories;

  @override
  _ListAccessoriesAct createState() => _ListAccessoriesAct();
}

class _ListAccessoriesAct extends State<ListAccessoriesAct> {
  final acts = FirebaseFirestore.instance.collection("acts");

  bool isRetrieved = false;
  var lists = [], listUrl = [], listName = [];
  List listId = [];

  @override
  void initState() {
    List _lists = [];
    List _listId = [];
    List _listUrl = [];
    List _listName = [];
    final actAcc = FirebaseFirestore.instance.collection("acts").doc(widget.id).collection('accessory');
Future(() async {
  await actAcc.get().then((querySnapshot) {
    _lists.clear();
    _listId.clear();
    dynamic values = querySnapshot.docs;
    values.asMap().forEach((key, values) async {
      _lists.add(values.data());
      _listId.add(values.id);
    });
  });
  }).then((value) async {
  _listUrl.clear();
  for (var i = 0; i < _lists.length; i++) {
    _listUrl.add(await accessoryUrl(_lists[i]['accId']));
    _listName.add(await accessoryName(_lists[i]['accId']));
  }
  setState(() {
    lists = _lists;
    listId = _listId;
    listUrl = _listUrl;
    listName = _listName;
  });
});



    super.initState();

  }
/*
  @override
  void dispose() {
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + ':  ' + widget.name),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListAccessoriesAdd(
                        title: "Список аксессуаров",
                        id: widget.id,
                        accessories: widget.accessories)),
              );
              setState(() {});
            }),
        body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(lists[index]["name"] +
                            '-----' +
                            lists[index]["accId"]),
                        leading: lists[index]["url"] != null
                            ? CachedNetworkImage(
                                imageUrl: lists[index]["url"],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) {
                                  return Icon(Icons.error);
                                },
                              )
                            //                  Image.network(lists[index]["url"])
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            var _per = listId[index];
                            await acts
                                .doc(widget.id)
                                .collection('accessory')
                                .doc(_per)
                                .delete()
                                .then((_) async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Удалено')));
                              dynamic _count = await accessoryValue(widget.id);
                              await acts
                                  .doc(widget.id)
                                  .update({'accessories': _count});
                            }).catchError((onError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(onError)));
                            });
                            setState(() {});
                          },
                        ),
                        onTap: () {},
                      );
                    }));

  }
}

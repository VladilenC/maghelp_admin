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
  /*
  final Stream<QuerySnapshot> accessories = FirebaseFirestore.instance
      .collection("accessories")
      .orderBy('name')
      .snapshots();
 */
  bool isRetrieved = false;
  var lists = [];
  List<String> listId = [];
/*
  getAccessories(id) async {
    return await acts.doc(id).collection('accessories').doc().get();
  }
*/
  @override
  Widget build(BuildContext context) {
    //  print('000000');
    //  print(getAccessories(widget.id));
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
        body: StreamBuilder<QuerySnapshot>(
            stream: acts.doc(widget.id).collection('accessory').snapshots(),
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
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}

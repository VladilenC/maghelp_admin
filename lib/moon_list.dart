import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class ListMoon extends StatefulWidget {
  ListMoon({Key? key, this.title}) : super(key: key);
  final dynamic title;

  @override
  _ListMoon createState() => _ListMoon();
}

class _ListMoon extends State<ListMoon> {
  final Stream<QuerySnapshot> typesStream = FirebaseFirestore.instance
      .collection("types")
      .orderBy('name')
      .snapshots();
  CollectionReference types = FirebaseFirestore.instance.collection("types");
  var lists = [];
  List<String> listId = [];
  /*
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _columnController;
  late ScrollController _columnController2;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _columnController = _controllers.addAndGet();
    _columnController2 = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _columnController.dispose();
    _columnController2.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Лунный календарь'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: typesStream,
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

                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        //                    maxCrossAxisExtent: 200,
                        childAspectRatio: 20,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Row(children: [
                        Container(
                            width: 100, child: Text(lists[index]["name"])),
                        Row(
                            children: List.generate(30, (index2) {
                          return Container(
                              width: 40,
                              child: TextFormField(
                                initialValue:
                                    lists[index]["m${index2 + 1}"].toString(),
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: (index2 + 1).toString(),
                                  labelStyle: TextStyle(color: Colors.red),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-5]")),
                                ],
                                onChanged: (text) {
                                  types.doc(listId[index]).update({
                                    "m${index2 + 1}": text,
                                  });
                                },
                              ));
                        }))
                      ]);
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}

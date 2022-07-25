import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/Edit/act_edit.dart';
import 'package:maghelp_add_act/List/accessories_act_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:http/http.dart' as http;
//import 'package:url_launcher/url_launcher.dart';

class ListActsOriginal extends StatefulWidget {
  ListActsOriginal(
      {Key? key, this.title, this.event, this.acts, this.accessories})
      : super(key: key);
  final title;
  final event;
  final acts;
  final accessories;

  @override
  _ListActsOriginal createState() => _ListActsOriginal();
}

class _ListActsOriginal extends State<ListActsOriginal> {
  var lists = [];
  List<String> listId = [];
  var selectEmpty = false, selectBad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
          Text(widget.title),
          SizedBox(
            width: 20,
          ),
          const Text('Пустые: '),
          !selectBad
              ? Checkbox(
                  value: selectEmpty,
                  onChanged: (bool? value) {
                    setState(() {
                      selectEmpty = value!;
                      if (selectEmpty) selectBad = false;
                    });
                  })
              : Container(),
          SizedBox(
            width: 20,
          ),
          const Text('Битые: '),
          !selectEmpty
              ? Checkbox(
                  value: selectBad,
                  onChanged: (bool? value) {
                    setState(() {
                      selectBad = value!;
                      if (selectBad) selectEmpty = false;
                    });
                  })
              : Container(),
        ])),
        body: StreamBuilder<QuerySnapshot>(
            stream: widget.acts,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                dynamic values;
                lists.clear();
                listId.clear();
                if (selectEmpty) {
                  values = widget.event != null
                      ? snapshot.data!.docs
                          .where((element) =>
                              element['event'] == widget.event &&
                              element['accessories'] == 0)
                          .toList()
                      : snapshot.data!.docs
                          .where((element) => element['accessories'] == 0)
                          .toList();
                } else {
                  if (selectBad) {
                    values = widget.event != null
                        ? snapshot.data!.docs
                            .where((element) =>
                                element['event'] == widget.event &&
                                element['badAcc'] == 1)
                            .toList()
                        : snapshot.data!.docs
                            .where((element) => element['badAcc'] == 1)
                            .toList();
                  } else {
                    values = widget.event != null
                        ? snapshot.data!.docs
                            .where(
                                (element) => element['event'] == widget.event)
                            .toList()
                        : snapshot.data!.docs.toList();
                  }
                }
                values.asMap().forEach((key, values) {
                  lists.add(values.data());
                  listId.add(values.id);
                });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("ID: " + listId[index]),
                            Text("Тип: " + lists[index]["type"]),
                            Text("Событие: " + lists[index]["event"]),
                            Text("Название: " + lists[index]["name"]),
                            Text("Описание: " + lists[index]["description"]),
                            lists[index]["url"] != null &&
                                    lists[index]["url"] != ''
                                ? CachedNetworkImage(
                                    imageUrl: lists[index]["url"],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                      return Icon(Icons.error);
                                    },
                                  )
                                //                    Image.network(lists[index]["url"])
                                : Container(),
                            lists[index]["description2"] != null
                                ? Text(lists[index]["description2"])
                                : Container(),
                            lists[index]["url2"] != null &&
                                    lists[index]["url2"] != ''
                                ? CachedNetworkImage(
                                    imageUrl: lists[index]["url2"],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                //                    Image.network(lists[index]["url2"])
                                : Container(),
                            lists[index]["description3"] != null
                                ? Text(lists[index]["description3"])
                                : Container(),
                            lists[index]["url3"] != null &&
                                    lists[index]["url3"] != ''
                                ? CachedNetworkImage(
                                    imageUrl: lists[index]["url3"],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                //                     Image.network(lists[index]["url3"])
                                : Container(),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ActEdit1(
                                                  nom: index.toString(),
                                                  id: listId[index],
                                                  name: lists[index]["name"],
                                                  type: lists[index]["type"],
                                                  event: lists[index]["event"],
                                                  description: lists[index]
                                                      ["description"],
                                                  description2: lists[index]
                                                      ["description2"],
                                                  description3: lists[index]
                                                      ["description3"],
                                                  url: lists[index]["url"],
                                                  url2: lists[index]["url2"],
                                                  url3: lists[index]["url3"],
                                                  title: "Редактирование")),
                                        );
                                        setState(() {});
                                      },
                                      child: Text('Изменить')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: lists[index]['badAcc'] != null &&
                                              lists[index]['badAcc'] == 1
                                          ? Colors.red
                                          : (lists[index]['accessories'] !=
                                                      null &&
                                                  lists[index]['accessories'] >
                                                      0
                                              ? Colors.green
                                              : Colors.yellow),
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 5,
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListAccessoriesAct(
                                                  title: "Аксессуары ",
                                                  id: listId[index],
                                                  name: lists[index]["name"],
                                                  accessories:
                                                      widget.accessories,
                                                )),
                                      );
                                    },
                                    child: lists[index]['accessories'] != null
                                        ? Text('Аксессуары' +
                                            '     ' +
                                            lists[index]['accessories']
                                                .toString())
                                        : Text('Аксессуары' + '     0'),
                                  )
                                ]),
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}

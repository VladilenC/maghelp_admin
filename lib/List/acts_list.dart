import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Utils/helpers.dart';

class ListActs extends StatefulWidget {
  ListActs({Key? key, this.title, this.event, this.acts, this.accessories})
      : super(key: key);
  final title;
  final event;
  final acts;
  final accessories;

  @override
  _ListActs createState() => _ListActs();
}

class _ListActs extends State<ListActs> {
  final acts = FirebaseFirestore.instance.collection("acts");
var finish = false;
  @override
  void initState() {
    super.initState();

    Future(() async {
      CollectionReference qqq;
      dynamic i = 0, xxx;
      if (widget.event != null) {
        await acts
            .where('event', isEqualTo: widget.event)
            .get()
            .then((value) async {
          for (var val in value.docs) {
            i = i + 1;
            print(i.toString());

            xxx = await accessoryValue(val.id);
            qqq = val.reference.collection('accessory');
            var element = await qqq.get();
            await acts.doc(val.id).update({'badAcc': 0, 'accessories': xxx});
            for (var val1 in element.docs) {
              if ((val1.data() as dynamic)!['accId'] == '') {
                await acts.doc(val.id).update({'badAcc': 1});
                break;
              }
            }
          }
        });
      } else {
        await acts.get().then((value) async {
          for (var val in value.docs) {
            i = i + 1;
            print(i.toString());

            xxx = await accessoryValue(val.id);
            qqq = val.reference.collection('accessory');
            var element = await qqq.get();
            await acts.doc(val.id).update({'badAcc': 0, 'accessories': xxx});
            for (var val1 in element.docs) {
              if ((val1.data() as dynamic)!['accId'] == '') {
                await acts.doc(val.id).update({'badAcc': 1});
                break;
              }
            }
          }
        });
      }

    }).then((value) {
      setState(() {
        finish = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: finish ? Container():CircularProgressIndicator()
        /*
        listId.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: listSw.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*
                        Text("ID: " + listId[index]),
                        Text("Тип: " + lists[index]["type"]),
                        Text("Событие: " + lists[index]["event"]),
                        Text("Название: " + lists[index]["name"]),
                        Text("Описание: " + lists[index]["description"]),
                        lists[index]["url"] != null && lists[index]["url"] != ''
                            ? CachedNetworkImage(
                                imageUrl: lists[index]["url"],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
                        */
                        listSw[index] != null &&
                                listSw[index] != ''
                            ? CachedNetworkImage(
                                imageUrl: listSw[index],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) {
                                  acts.doc(listId[index]).update({'badAcc': 1});
                                  print(listId[index].toString());
                                    return Icon(Icons.error);},
                              )
                            //                     Image.network(lists[index]["url3"])
                            : Container(),
                        /*
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  primary: listEmp[index] > 0 ? Colors.green:Colors.yellow,
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
                                              accessories: widget.accessories,
                                            )),
                                  );
                                },
                                child: Text('Аксессуары     ' +
                                    listEmp[index].toString()),
                              )
                            ]),
                        */
                      ],
                    ),
                  );
                })
            : CircularProgressIndicator()

    */
        );
  }
}

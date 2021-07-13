import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Edit/accessory_edit.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class ListAccessories extends StatefulWidget {
  ListAccessories({Key key, this.title}) : super(key: key);
  final dynamic title;

  @override
  _ListAccessories createState() => _ListAccessories();
}

class _ListAccessories extends State<ListAccessories> {
  final accessories = FirebaseFirestore.instance.collection("accessories");
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  QuerySnapshot cachedResult;
  bool isRetrieved = false;
  List<Map<dynamic, dynamic>> lists = [];
  List<String> listId = [];
  int _selectedIndex=-1;
  String textSearch = '';
  var _ev;

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Аксессуары: '+textSearch),
        actions: [searchBar.getSearchAction(context)]
    );
  }

  _ListAccessories() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (text) {
          print(text);
          setState(() {
            textSearch = text;
          });
        },
        buildDefaultAppBar: buildAppBar
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        body: FutureBuilder<QuerySnapshot>(
            future: accessories.orderBy('name').get().then((querySnapshot) {
              querySnapshot.docs.forEach((result) {

              }
              );

              return querySnapshot;
            }),

            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                listId.clear();
                final List<DocumentSnapshot> values = snapshot.data.docs;
                if (textSearch == null || textSearch == '') {
                values.asMap().forEach((key, values) {
                  lists.add(values.data());
                  listId.add(values.id);
                });}
                else {
                  values.asMap().forEach((key, values) {
                    if (values['name'].toString().toLowerCase().contains(textSearch)) {
                    lists.add(values.data());
                    listId.add(values.id);
                  }});
                }
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context,  index) {
         //             snapshot.data.docs[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text("Название: " + lists[index]["name"]),
                        leading: snapshot.data.docs[index]["url"] != null ? Image.network(snapshot.data.docs[index]["url"]):null,
                        onTap: ()  async {
                          _ev = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccessoryEdit1(nom: index.toString(), url: snapshot.data.docs[index]["url"], id: listId[index] ,name: lists[index]["name"], title: "Редактирование")),
                          );
                          setState(() {

                          });

                        },
                      );
                       Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            snapshot.data.docs[index]["url"] != null ? Image.network(snapshot.data.docs[index]["url"]):null,
                            Text("Название: " + lists[index]["name"]),
                          ],
                        ),
                      );


                    });
              }
              return CircularProgressIndicator();
            }
        )

          );
  }

  Future<QuerySnapshot> getImages() {

    return accessories.doc().collection("accessories").get();
  }

putImage(ind)  {

    var ev =  accessories.doc(ind).update({"url": cachedResult.docs[ind]["url"], "name": cachedResult.docs[ind]["name"]}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено')));
    }).catchError((onError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(onError)));
    });




 Navigator.pop(
        context, {"url": cachedResult.docs[ind]["url"], "name": cachedResult.docs[ind]["name"]}
    );
  }

  ListView displayCachedList() {
    isRetrieved = true;

    return ListView.builder(
        shrinkWrap: true,
        itemCount: cachedResult.docs.length,
        itemBuilder: (BuildContext context, int index) {
          print(cachedResult.docs[index]["url"]);
          print('111');
           return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(cachedResult.docs[index]["name"]),
            leading: Image.network(cachedResult.docs[index]["url"],
                fit: BoxFit.fill),
          );
        });
  }
}

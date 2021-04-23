import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database_tutorial/events_edit.dart';

class ListImages extends StatefulWidget {
  ListImages({Key key, this.title}) : super(key: key);
  final dynamic title;

  @override
  _ListImages createState() => _ListImages();
}

class _ListImages extends State<ListImages> {
  final events = FirebaseFirestore.instance.collection("events");
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  QuerySnapshot cachedResult;
  bool isRetrieved = false;
  List<Map<dynamic, dynamic>> lists = [];
  List<String> listId = [];
  int _selectedIndex=-1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),








        body:
        FutureBuilder(
        future: getImages(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
    isRetrieved = true;
    cachedResult = snapshot.data;


    return Column(
      children: [
        Text(
            _selectedIndex==-1?"Не выбрано": "Выбрано: ${snapshot.data.docs[_selectedIndex].data()["name"]}",
            style: TextStyle(fontSize: 20)),
        ListView.builder(
    shrinkWrap: true,
    itemCount: snapshot.data.docs.length,
    itemBuilder: (BuildContext context, int index) {
    return
      ListTile(
      onTap: () {
        print('ddddd: '+index.toString());
        setState(() {
          // устанавливаем индекс выделенного элемента
          _selectedIndex = index;
          return index;
        });
      },
      selected: index == _selectedIndex,
      selectedTileColor: Colors.lightBlueAccent,
    contentPadding: EdgeInsets.all(8.0),
    title: Text(
    snapshot.data.docs[index].data()["name"], style: TextStyle(color: Colors.black),),
    leading: Image.network(
    snapshot.data.docs[index].data()["url"],
    fit: BoxFit.fill),
    );
    }),

      ]);
    } else if (snapshot.connectionState ==
    ConnectionState.none) {
    return Text("Нет данных");
    }
    return CircularProgressIndicator();
    },
    )

          );
  }

  Future<QuerySnapshot> getImages() {
    print('333');
    return fb.collection("images").get();
  }

  ListView displayCachedList() {
    isRetrieved = true;

    return ListView.builder(
        shrinkWrap: true,
        itemCount: cachedResult.docs.length,
        itemBuilder: (BuildContext context, int index) {
          print(cachedResult.docs[index].data()["url"]);
          print('111');
          print(isRetrieved);
          print(cachedResult.docs.length);
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(cachedResult.docs[index].data()["name"]),
            leading: Image.network(cachedResult.docs[index].data()["url"],
                fit: BoxFit.fill),
          );
        });
  }
}

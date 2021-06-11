import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/Edit/event_edit.dart';

class ListImages2 extends StatefulWidget {
  ListImages2({Key key, this.title,this.id}) : super(key: key);
  final dynamic title;
  final dynamic id;

  @override
  _ListImages2 createState() => _ListImages2();
}

class _ListImages2 extends State<ListImages2> {
  final acts = FirebaseFirestore.instance.collection("acts");
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
print(snapshot.data.docs.length);

    return
        ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int index) {
          return
               ListTile(
                onTap: () {
                   print(index);
                   setState(() {
                     print(index);
              // устанавливаем индекс выделенного элемента
                     _selectedIndex = index;
        //  if (widget.id!=null) {
                      putImage(index);
        //  }

     //     return index;
                   });
                },
                selected: index == _selectedIndex,
                selectedTileColor: Colors.lightBlueAccent,
                contentPadding: EdgeInsets.all(8.0),
                title: Text(snapshot.data.docs[index]["name"], style: TextStyle(color: Colors.black),),
                leading: Image.network(snapshot.data.docs[index]["url"],
                fit: BoxFit.fill),
              );
        });


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

    return fb.collection("pictures").get();
  }

putImage(ind) {
    if (widget.id!=null) {

    print('4444: '+ind.toString());
    print(acts.doc(widget.id));
    var ev = acts.doc(widget.id).update({"url": cachedResult.docs[ind]["url"], "pic": cachedResult.docs[ind]["name"]}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено')));
    }).catchError((onError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(onError)));
    });}
    Navigator.pop(
        context, {"url": cachedResult.docs[ind]["url"], "pic": cachedResult.docs[ind]["name"]}
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

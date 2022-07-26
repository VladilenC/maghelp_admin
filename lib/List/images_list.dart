import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/Edit/image_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListImages extends StatefulWidget {
  ListImages({Key? key, this.title, this.id}) : super(key: key);
  final dynamic title;
  final dynamic id;

  @override
  _ListImages createState() => _ListImages();
}

class _ListImages extends State<ListImages> {
  final Stream<QuerySnapshot> images = FirebaseFirestore.instance.collection("images").orderBy('name').snapshots();
  var cachedResult;
  bool isRetrieved = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
      /*
        FutureBuilder(
          future: getImages(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              isRetrieved = true;
              cachedResult = snapshot.data;
    */
        StreamBuilder<dynamic> (
          stream: images,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              isRetrieved = true;
              cachedResult = snapshot.data;
              print(snapshot.data!.docs.length);


              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            putImage(index);
                          });
                        },
                        selected: index == _selectedIndex,
                        selectedTileColor: Colors.lightBlueAccent,
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(
                          snapshot.data!.docs[index]["name"],
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: CachedNetworkImage(
                          imageUrl: snapshot.data!.docs[index]["url"],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
             //                           Image.network(snapshot.data!.docs[index]["url"], fit: BoxFit.fill),
                        );
                  });
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("Нет данных");
            }
            return CircularProgressIndicator();
          },
        ));
  }
/*
  Future<QuerySnapshot> getImages() {
    return fb.collection("images").get();
  }
*/
  putImage(ind) async {
    if (widget.id != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageEdit1(
                nom: ind.toString(),
                url: cachedResult.docs[ind]["url"],
                id: cachedResult.docs[ind].id,
                name: cachedResult.docs[ind]["name"],
                title: "Редактирование")),
      );
      setState(() {});
    } else {
      Navigator.pop(context, {
        "url": cachedResult.docs[ind]["url"],
        "pic": cachedResult.docs[ind]["name"]
      });
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Edit/picture_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListPicture extends StatefulWidget {
  ListPicture({Key? key, this.title, this.id}) : super(key: key);
  final dynamic title;
  final dynamic id;

  @override
  _ListPicture createState() => _ListPicture();
}

class _ListPicture extends State<ListPicture> {
  final Stream<QuerySnapshot> pictures = FirebaseFirestore.instance
      .collection("pictures")
      .orderBy('name')
      .snapshots();
  var cachedResult;
  bool isRetrieved = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder<dynamic>(
          stream: pictures,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              isRetrieved = true;
              cachedResult = snapshot.data;
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
                        //              Image.network(snapshot.data!.docs[index]["url"], fit: BoxFit.fill),
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
  Stream getImages() {
    return fb.collection("pictures").snapshots();
  }
*/
  putImage(ind) async {
    if (widget.id != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PictureEdit(
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

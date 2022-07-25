import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListImages3 extends StatefulWidget {
  ListImages3({Key? key, this.title, this.id}) : super(key: key);
  final dynamic title;
  final dynamic id;

  @override
  _ListImages3 createState() => _ListImages3();
}

class _ListImages3 extends State<ListImages3> {
  final acts = FirebaseFirestore.instance.collection("acts");
  final Stream<QuerySnapshot> accessories = FirebaseFirestore.instance
      .collection("accessories")
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
        body:
/*
        FutureBuilder(
          future: getImages(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              isRetrieved = true;
              cachedResult = snapshot.data;
*/
            StreamBuilder<dynamic>(
          stream: accessories,
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
                            if (widget.id != null) {
                              putImage(index);
                            }
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
                        //                 Image.network(snapshot.data!.docs[index]["url"], fit: BoxFit.fill),
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
    return fb.collection("accessories").get();
  }
*/
  putImage(ind) {
    if (widget.id != null) {
      acts.doc(widget.id).collection('accessory').add({
        "url": cachedResult.docs[ind]["url"],
        "name": cachedResult.docs[ind]["name"]
      }).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Сохранено')));
      }).catchError((onError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(onError)));
      });
    }
    Navigator.pop(context, {
      "url": cachedResult.docs[ind]["url"],
      "name": cachedResult.docs[ind]["name"]
    });
  }
}

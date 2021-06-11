import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maghelp_add_act/List/images_list3.dart';

class ListAccessories extends StatefulWidget {
  ListAccessories({Key key, this.title,this.id, this.name}) : super(key: key);
  final dynamic title;
  final dynamic id;
  final dynamic name;

  @override
  _ListAccessories createState() => _ListAccessories();
}

class _ListAccessories extends State<ListAccessories> {
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
          title: Text(widget.title+':  '+widget.name),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () async {


           var _ac = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListImages3(title: "Список аксессуаров", id: widget.id)),
              );
      setState(() {

      });


    }

        ),
        body: FutureBuilder<QuerySnapshot>(
            future: acts.doc(widget.id).collection('accessory').get().then((querySnapshot) {
              querySnapshot.docs.forEach((result) {
                //                 var i1 = result.id;
                //                acts.doc(i1).update({'name': '1','url': '', 'description2': '', 'url2': '', 'description3': '', 'url3': ''});

//                  acts.doc(i1).collection('accessory').add({'name': '1','url': ''});
              }
              );

              return querySnapshot;
            }),

            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                //          acts.doc().set({'name': '2'});
                lists.clear();
                listId.clear();
                final List<DocumentSnapshot> values = snapshot.data.docs;
                values.asMap().forEach((key, values) {
                  //         acts.doc().update({'name': '3'});
                  lists.add(values.data());
                  listId.add(values.id);
                });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context,  index) {
                      snapshot.data.docs[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text("Название: " + lists[index]["name"]),
                        leading: snapshot.data.docs[index]["url"] != null ? Image.network(snapshot.data.docs[index]["url"]):null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            var _per = snapshot.data.docs[index].id;
                            print('0000000000000');
                            print(_per);
                            print('1111111111');
                            var ev = await acts.doc(widget.id).collection('accessory').doc(_per).delete().then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Удалено')));
                            }).catchError((onError) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(onError)));
                            });
                            setState(() {

                            });
                          },
                        ),
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

    return acts.doc().collection("accessories").get();
  }

putImage(ind)  {
    if (widget.id!=null) {

    print('4444: '+ind.toString());
    print(acts.doc(widget.id));
    var ev =  acts.doc(widget.id).collection('accessory').doc().update({"url": cachedResult.docs[ind]["url"], "name": cachedResult.docs[ind]["name"]}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено')));
    }).catchError((onError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(onError)));
    });

    print('99999999999');
    print(acts.doc(widget.id).collection('accessory').doc());

    }
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

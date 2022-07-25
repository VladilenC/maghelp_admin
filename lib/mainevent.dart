//import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maghelp_add_act/List/events_list.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'List/images_list.dart';

class MyEvent extends StatefulWidget {
  MyEvent({Key? key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  final _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> types = FirebaseFirestore.instance
      .collection("types")
      .orderBy('name')
      .snapshots();
  final Stream<QuerySnapshot> subtypes = FirebaseFirestore.instance
      .collection("subtypes")
      .orderBy('name')
      .snapshots();
  final Stream<QuerySnapshot> eventsStream = FirebaseFirestore.instance
      .collection("events")
      .orderBy('name')
      .snapshots();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var selectType, _url, url, selectSub, selectEv;
  var desItems, urlItems, nameItems, idItems;
  var kol;
  CollectionReference events = FirebaseFirestore.instance.collection("events");

  @override
  void initState() {
    super.initState();
    events.get().then((value) async {
      setState(() {
        kol = value.docs.length;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  SizedBox(height: 10.0),
                  StreamBuilder<QuerySnapshot>(
                      stream: types,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null)
                          return SizedBox(
                              height: 36,
                              width: 16,
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              )));
                        else {
                          List<DropdownMenuItem> typeItems = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            typeItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap['name'],
                                  style: TextStyle(color: Colors.blue),
                                ),
                                value: "${snap.id}",
                              ),
                            );
                          }
                          return Row(
                   //         mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(width: 200),
                              Row(
                          children: [

                              Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 50.0,
                              ),
                              DropdownButton<dynamic>(
                                items: typeItems,
                                onChanged: (typeValue) {
                                  setState(() {
                                    selectType = typeValue;
                                    selectSub = null;
                                    selectEv = null;
                                    nameController.clear();
                                    descriptionController.clear();
                                    url = null;
                                  });
                                },
                                value: selectType,
                                isExpanded: false,
                                hint: Text(
                                  'Выберите тип',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              selectType != null
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectType = null;
                                          selectSub = null;
                                          selectEv = null;
                                          nameController.clear();
                                          descriptionController.clear();
                                          url = null;
                                        });
                                      },
                                      icon: Icon(Icons.cancel),
                                      color: Colors.red,
                                    )
                                  : Container()]),
                              SizedBox(width: 100),
                              Text(kol.toString())
                            ],
                          );
                        }
                      }),
                  SizedBox(height: 10.0),
                  StreamBuilder<QuerySnapshot>(
                      stream: subtypes,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return SizedBox(
                              height: 36,
                              width: 16,
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              )));
                        else {
                          List<DropdownMenuItem> subItems = [];
                          final snap = selectType != null
                              ? snapshot.data!.docs
                                  .where((element) =>
                                      element['typeid'] == selectType)
                                  .toList()
                              : snapshot.data!.docs.toList();
                          for (int i = 0; i < snap.length; i++) {
                            subItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap[i]['name'],
                                  style: TextStyle(color: Colors.blue),
                                ),
                                value: "${snap[i].id}",
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 50.0,
                              ),
                              DropdownButton<dynamic>(
                                items: subItems,
                                onChanged: (subValue) {
                                  setState(() {
                                    selectSub = subValue;
                                    selectEv = null;
                                    nameController.clear();
                                    descriptionController.clear();
                                    url = null;
                                  });
                                },
                                value: selectSub,
                                isExpanded: false,
                                hint: Text(
                                  'Выберите подтип',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              selectSub != null
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectSub = null;
                                          selectEv = null;
                                          nameController.clear();
                                          descriptionController.clear();
                                          url = null;
                                        });
                                      },
                                      icon: Icon(Icons.cancel),
                                      color: Colors.red,
                                    )
                                  : Text('')
                            ],
                          );
                        }
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: eventsStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return SizedBox(
                              height: 36,
                              width: 16,
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              )));
                        else {
                          List<DropdownMenuItem> eventItems = [];
                          desItems = [];
                          urlItems = [];
                          nameItems = [];
                          idItems = [];
                          final snap = selectSub != null
                              ? snapshot.data!.docs
                                  .where((element) =>
                                      element['subtype'] == selectSub)
                                  .toList()
                              : snapshot.data!.docs.toList();
                          for (int i = 0; i < snap.length; i++) {
                            eventItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap[i]['name'],
                                  style: TextStyle(color: Colors.blue),
                                ),
                                value: "${snap[i].id}",
                              ),
                            );
                            snap[i]['description'] != null
                                ? desItems.add(snap[i]['description'])
                                : desItems.add('');
                            snap[i]['url'] != null
                                ? urlItems.add(snap[i]['url'])
                                : urlItems.add('');
                            snap[i]['name'] != null
                                ? nameItems.add(snap[i]['name'])
                                : nameItems.add('');
                            idItems.add(snap[i].id);
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 50.0,
                              ),
                              DropdownButton<dynamic>(
                                items: eventItems,
                                onChanged: (evValue) {
                                  setState(() {
                                    selectEv = evValue;
                                    var _i = idItems.indexOf(evValue);
                                    nameController.text = nameItems[_i];
                                    descriptionController.text = desItems[_i];
                                    url = urlItems[_i];
                                  });
                                },
                                value: selectEv,
                                isExpanded: false,
                                hint: Text(
                                  'Выберите событие',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              selectEv != null
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectEv = null;
                                          nameController.clear();
                                          descriptionController.clear();
                                          url = null;
                                        });
                                      },
                                      icon: Icon(Icons.cancel),
                                      color: Colors.red,
                                    )
                                  : Text('')
                            ],
                          );
                        }
                      }),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: nameController,
                    maxLines: 2,
                    decoration: InputDecoration(
                        labelText: 'Введите название',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: _url != null
                          ? Image.network(_url)
                          : url != null
                              ? Image.network(url)
                              : Text('Нет картинки',
                                  textAlign: TextAlign.center)),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                                child: Text("Выбор картинки"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  onPrimary: Colors.white,
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                ),
                                onPressed: () async {
                                  var _url0 = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListImages(
                                            title: "Выбор картинки", id: null)),
                                  );
                                  setState(() {
                                    _url = _url0['url'];
                                  });
                                })
                          ])),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      selectEv == null
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                onPrimary: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                              onPressed: () {
                                if (selectType != null &&
                                    selectSub != null &&
                                    nameController.text.trim() != '') {
                                  if (_formKey.currentState!.validate()) {
                                    events.doc().set({
                                      "name": nameController.text,
                                      "description": descriptionController.text,
                                      "subtype": selectSub,
                                      "type": selectType,
                                      'url': _url,
                                      //                                            "pic": _pic
                                    }).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Добавлено')));
                                      nameController.clear();
                                      descriptionController.clear();
                                      selectType = null;
                                      selectSub = null;
                                      _url = null;
                                      //                                          _pic = null;
                                    }).catchError((onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(onError)));
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Не добавлено. Поля не могут быть пустыми')));
                                }
                              },
                              child: Text('Добавить'),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                onPrimary: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                              onPressed: () {
                                if (selectEv != null &&
                                    nameController.text.trim() != '') {
                                  if (_formKey.currentState!.validate()) {
                                    events.doc(selectEv).update({
                                      "name": nameController.text,
                                      "description": descriptionController.text,
                                      'url': _url != null && _url != ''
                                          ? _url
                                          : url,
                                    }).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Изменено')));
                                      setState(() {
                                        nameController.clear();
                                        selectType = null;
                                        selectSub = null;
                                        selectEv = null;
                                        descriptionController.clear();
                                        _url = null;
                                        url = null;
                                      });
                                    }).catchError((onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(onError)));
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Не изменено. название не может быть пустым')));
                                }
                              },
                              child: Text('Изменить'),
                            ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          onPrimary: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListEvents(
                                    title: "Список событий",
                                    subtype: selectSub)),
                          );
                        },
                        child: Text('Список'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10)
                ])));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
}

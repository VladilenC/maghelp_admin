//import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'List/subtypes_list.dart';
import 'List/images_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MySubType extends StatefulWidget {
  MySubType({Key? key, this.types}) : super(key: key);
  final types;

  @override
  _MySubTypeState createState() => _MySubTypeState();
}

class _MySubTypeState extends State<MySubType> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference subtypes =
  FirebaseFirestore.instance.collection("subtypes");
  final Stream<QuerySnapshot> typeStream = FirebaseFirestore.instance
      .collection('types')
      .orderBy('name')
      .snapshots();
  final Stream<QuerySnapshot> subtypeStream = FirebaseFirestore.instance
      .collection('subtypes')
      .orderBy('name')
      .snapshots();

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var selectType, selectSub, url, _url;
  var desItems, urlItems, nameItems, idItems;

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
                      stream: typeStream,
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
                                items: typeItems,
                                onChanged: (typeValue) {
                                  setState(() {
                                    selectType = typeValue;
                                    selectSub = null;
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
                  StreamBuilder<QuerySnapshot>(
                      stream: subtypeStream,
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
                          List<DropdownMenuItem> typeSubs = [];
                          desItems = [];
                          urlItems = [];
                          nameItems = [];
                          idItems = [];
                          var snap = selectType != null
                              ? snapshot.data!.docs
                              .where((element) =>
                          element['typeid'] == selectType)
                              .toList()
                              : snapshot.data!.docs.toList();
                          for (int i = 0; i < snap.length; i++) {
                            typeSubs.add(
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
                                items: typeSubs,
                                onChanged: (subValue) {
                                  setState(() {
                                    selectSub = subValue;
                                    var _i =
                                    idItems.indexOf(subValue.toString());
                                    nameController.text = nameItems[_i];
                                    descriptionController.text = desItems[_i];
                                    url = urlItems[_i];
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
                  SizedBox(height: 10.0),
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
                      //             child: _url!=null ? Image.network(_url) : Text('Нет картинки')),
                      child: _url != null
                          ? Image.network(_url)
                          : (url != null
                          ? CachedNetworkImage(
                        imageUrl: url,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      )
                      //                   Image.network(url)
                          : Text('Не выбрано',
                          textAlign: TextAlign.center))),
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
                      selectSub == null
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          onPrimary: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 5,
                        ),
                        onPressed: () {
                          if (selectType != null &&
                              nameController.text.trim() != '') {
                            if (_formKey.currentState!.validate()) {
                              subtypes.doc().set({
                                "name": nameController.text,
                                "description": descriptionController.text,
                                "typeid": selectType,
                                'url': _url
                              }).then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text('Добавлено')));
                                nameController.clear();
                                selectType = null;
                                selectSub = null;
                                descriptionController.clear();
                                _url = null;
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
                          setState(() {});
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
                          if (selectSub != null &&
                              nameController.text.trim() != '') {
                            if (_formKey.currentState!.validate()) {
                              subtypes.doc(selectSub).update({
                                "name": nameController.text,
                                "description": descriptionController.text,
                                "typeid": selectType,
                                'url': _url != null ? _url : url,
                              }).then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text('Изменено')));
                                setState(() {
                                  nameController.clear();
                                  selectType = null;
                                  selectSub = null;
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
                          setState(() {});
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
                                builder: (context) => ListSubtypes(
                                    title: "Список подтипов", type: selectType),
                              ));
                        },
                        child: Text('Список'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10)
                ])));
  }
/*
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
  */
}

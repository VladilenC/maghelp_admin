import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maghelp_add_act/List/accessories_list.dart';
import 'package:maghelp_add_act/List/acts_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maghelp_add_act/List/images_list2.dart';



class MyAct extends StatefulWidget {
  MyAct({Key key}) : super(key: key);

  @override
  _MyActState createState() => _MyActState();
}

class _MyActState extends State<MyAct> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final descriptionController2 = TextEditingController();
  final descriptionController3 = TextEditingController();
  dynamic selectType, selectEvent, _url, _pic, _url2, _pic2, _url3, _pic3;
  final typeItems = ["Ритуал", "Заговор", "Оберег", "Народный рецепт", "Практический совет"];

  @override
  Widget build(BuildContext context) {
    CollectionReference  acts = FirebaseFirestore.instance.collection("acts");
    return
      Scaffold(
          body: Form(
              key: _formKey,
              child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.check,
                                  size: 25.0,
                                  color: Colors.blue,),
                                SizedBox(width: 50.0,),
                                DropdownButton(
                                  items: typeItems
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (typeValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбран тип $typeValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectType = typeValue;
                                    });
                                  },
                                  value: selectType,
                                  isExpanded: false,
                                  hint: Text('Выберите тип',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                   SizedBox(height: 10.0),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('events').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return
                              SizedBox(
                                height: 35,
                                width: 0,
                                child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    )
                                )
                            );
                          else {
                            List <DropdownMenuItem> typeSubs = [];
                            for (int i = 0; i <
                                snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              typeSubs.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap.id,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  value: "${snap.id}",
                                ),
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.check,
                                  size: 25.0,
                                  color: Colors.blue,),
                                SizedBox(width: 50.0,),
                                Flexible(child:
                                DropdownButton<dynamic>(
                                  items: typeSubs,

                                  onChanged: (subValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбрано событие: $subValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectEvent = subValue;
                                    });
                                  },
                                  value: selectEvent,
                                  isExpanded: true,
                                  hint: Text('Выберите событие',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                          )],
                            );
                          }
                        }),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: nameController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          labelText: 'Введите название',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Введите описание',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: _url!=null ? Image.network(_url) : Text('Нет картинки')),

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
                                          builder: (context) => ListImages2(title: "Выбор картинки", id: null)),
                                    );
                                    setState(() {
                                      _url = _url0['url'];
                                      _pic = _url0['pic'];
                                    });
                                  })])),

                    TextFormField(
                      controller: descriptionController2,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Введите описание2',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: _url2!=null ? Image.network(_url2) : Text('Нет картинки')),

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
                                          builder: (context) => ListImages2(title: "Выбор картинки", id: null)),
                                    );
                                    setState(() {
                                      _url2 = _url0['url'];
                                      _pic2 = _url0['pic'];
                                    });
                                  })])),

                    TextFormField(
                      controller: descriptionController3,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Введите описание3',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: _url3!=null ? Image.network(_url) : Text('Нет картинки')),

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
                                          builder: (context) => ListImages2(title: "Выбор картинки", id: null)),
                                    );
                                    setState(() {
                                      _url3 = _url0['url'];
                                      _pic3 = _url0['pic'];
                                    });
                                  })])),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            shadowColor: Colors.grey,
                            elevation: 5,
                          ),
                          onPressed: () {
                            if (selectType!=null && selectEvent!=null && descriptionController.text!=null) {
                            if (_formKey.currentState.validate()) {
                              acts.doc().set({
                                "name": nameController.text,
                                "description": descriptionController.text,
                                "description2": descriptionController2.text,
                                "description3": descriptionController3.text,
                                "event": selectEvent,
                                "type": selectType,
                                'url': _url,
                                "pic": _pic,
                                'url2': _url2,
                                "pic2": _pic2,
                                'url3': _url3,
                                "pic3": _pic3
                              }).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Добавлено')));
                                nameController.clear();
                                descriptionController.clear();
                                descriptionController2.clear();
                                descriptionController3.clear();
                                selectType.clear();
                                selectEvent.clear();
                              }).catchError((onError) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(onError)));
                              });
                            }
                          }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Не добавлено. Поля не могут быть пустыми')));
                            }
                            },
                          child: Text('Сохранить'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            shadowColor: Colors.grey,
                            elevation: 5,
                          ),
                          onPressed: () {


                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListAccessories(title: "Аксессуары", id: acts.doc().id, name: nameController.text)),
                            );

                            //                              Navigator.push(
                            //                                 context,
//                                  MaterialPageRoute(
//                                      builder: (context) => ListActs(title: "Home Page")),
//                                );
                          },
                          child: Text('Аксессуары'),
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
                                  builder: (context) => ListActs(title: "Список действий", event: selectEvent)),
                            );
                          },
                          child: Text('Список'),
                        ),
                      ],
                    ),
                  ]
              )
          )
      );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
}
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/acts_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class MyAct extends StatefulWidget {
  MyAct({Key key}) : super(key: key);

  @override
  _MyActState createState() => _MyActState();
}

class _MyActState extends State<MyAct> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  var selectType, selectEvent;
  final typeItems = ["Ритуал", "Заговор", "Оберег", "Народный рецепт", "Практический совет"];

  @override
  Widget build(BuildContext context) {
    CollectionReference  events = FirebaseFirestore.instance.collection("events");
    return
      Scaffold(


          body: Form(
              key: _formKey,
              child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  children: <Widget>[
                    SizedBox(height: 20.0),
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
                                    Scaffold.of(context).showSnackBar(snackBar);
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






                    SizedBox(height: 20.0),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('events').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            const Text("Loading.......");
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
                            };
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.check,
                                  size: 25.0,
                                  color: Colors.blue,),
                                SizedBox(width: 50.0,),
                                DropdownButton(
                                  items: typeSubs,

                                  onChanged: (subValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбрано событие: $subValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectEvent = subValue;
                                    });
                                  },
                                  value: selectEvent,
                                  isExpanded: false,
                                  hint: Text('Выберите событие',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );

                          }
                        }),
                    SizedBox(height: 20.0),

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
                    SizedBox(height: 20.0),

                    TextFormField(
                      controller: descriptionController,
                      maxLines: 12,
                      decoration: InputDecoration(
                          labelText: 'Введите описание',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),

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
                            if (_formKey.currentState.validate()) {
                              events.doc().set({
                                "description": nameController.text,
                                "event": selectEvent,
                                "type": selectType
                              }).then((_) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Добавлено')));
                                nameController.clear();
                                descriptionController.clear();
                                selectType.clear();
                                selectEvent.clear();
                              }).catchError((onError) {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text(onError)));
                              });
                            }
                          },
                          child: Text('Сохранить'),
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
                                  builder: (context) => Home_acts(title: "Список действий")),
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
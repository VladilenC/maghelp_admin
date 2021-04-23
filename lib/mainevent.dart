import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/events_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class MyEvent extends StatefulWidget {
  MyEvent({Key key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  var selectType, selectSub;

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
                    SizedBox(height: 10.0),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('types').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null)
                            return
                              SizedBox(
                                  height: 36,
                                  width: 16,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                      )

                                  ));

                          else {
                            List <DropdownMenuItem> typeItems = [];
                            for (int i = 0; i <
                                snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              typeItems.add(
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
                                DropdownButton<dynamic>(
                                  items: typeItems,
                                  onChanged: (typeValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбран тип $typeValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectType = typeValue;
                                   selectSub = null;
                                    });
                                  },
                                  value: selectType,
                                  isExpanded: false,
                                  hint: Text('Выберите тип',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),




                              ],
                            );

                          }
                        }),




                    SizedBox(height: 10.0),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('types').doc(selectType).collection('subs').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return
                              SizedBox(
                                height: 36,
                                width: 16,
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
                                DropdownButton<dynamic>(
                                  items: typeSubs,

                                  onChanged: (subValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбран подтип $subValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectSub = subValue;
                                    });
                                  },
                                  value: selectSub,
                                  isExpanded: false,
                                  hint: Text('Выберите подтип',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );

                          }
                        }),
SizedBox(height: 10.0),

TextFormField(
  controller: nameController,
    maxLines: 10,
    decoration: InputDecoration(
      labelText: 'Введите название',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0)
      )
    ),
),
                    SizedBox(height: 145.0),
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
                                          if (selectType!=null && selectSub!=null && nameController.text!=null) {


                                          if (_formKey.currentState.validate()) {
                                            events.doc(nameController.text).set({
                                              "name": nameController.text,
                                              "subtype": selectSub,
                                              "type": selectType
                                            }).then((_) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Добавлено')));
                                              nameController.clear();
                                              selectType.clear();
                                              selectSub.clear();
                                            }).catchError((onError) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text(onError)));
                                            });
                                          }
                                        }
                                          else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Не добавлено. Поля не могут быть пустыми')));
                                          }},
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
                                                builder: (context) => ListEvents(title: "Список событий")),
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
  }
}

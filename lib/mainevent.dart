import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maghelp_add_act/List/events_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'List/images_list.dart';



class MyEvent extends StatefulWidget {
  MyEvent({Key key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var selectType, _url, url, _pic, _description, _name, selectSub, selectEv;
  List desItems, urlItems, nameItems, idItems;

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
                        stream: FirebaseFirestore.instance.collection('subtypes').where('typeid', isEqualTo: selectType).snapshots(),
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
                            List <DropdownMenuItem> subItems = [];
                            for (int i = 0; i <
                                snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              subItems.add(
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
                                Icon(FontAwesomeIcons.check,
                                  size: 25.0,
                                  color: Colors.blue,),
                                SizedBox(width: 50.0,),
                                DropdownButton<dynamic>(
                                  items: subItems,
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
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('events').where('subtype', isEqualTo: selectSub).snapshots(),
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
                            List <DropdownMenuItem> eventItems = [];
                            desItems = [];
                            urlItems = [];
                            nameItems = [];
                            idItems =[];
                            print('000');
                            for (int i = 0; i <
                                snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              eventItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap['name'],
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  value: "${snap.id}",
                                ),
                              );
                              snap['description'] != null ? desItems.add(snap['description']): desItems.add('');
                              snap['url'] != null ? urlItems.add(snap['url']): urlItems.add('');
                              snap['name'] != null ? nameItems.add(snap['name']): nameItems.add('');
                              snap.id != null ? idItems.add(snap.id): idItems.add('');
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.check,
                                  size: 25.0,
                                  color: Colors.blue,),
                                SizedBox(width: 50.0,),
                                DropdownButton<dynamic>(
                                  items: eventItems,
                                  onChanged: (evValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбрано событие $evValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                  hint: Text('Выберите событие',
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
    maxLines: 2,
    decoration: InputDecoration(
      labelText: 'Введите название',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0)
      )
    ),
),

              Padding(
               padding: EdgeInsets.all(5.0),
                child: _url!=null ? Image.network(_url) : url != null ? Image.network(url):Text('Нет картинки')),

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
                          builder: (context) => ListImages(title: "Выбор картинки", id: null)),
                        );
                      setState(() {
_url = _url0['url'];
//_pic = _url0['pic'];
                      });
                  })])),
                    SizedBox(height: 5.0),
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
                                            events.doc().set({
                                              "name": nameController.text,
                                              "description": descriptionController.text,
                                              "subtype": selectSub,
                                              "type": selectType,
                                              'url': _url,
  //                                            "pic": _pic
                                            }).then((_) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Добавлено')));
                                              nameController.clear();
                                              descriptionController.clear();
                                              selectType.clear();
                                              selectSub.clear();
                                              _url = null;
    //                                          _pic = null;
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
                                          setState(() {
      //                                      _url = null;
    //                                        _pic = null;
                                          });},
                                        child: Text('Добавить'),
                                      ),
                                      selectEv != null ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.teal,
                                          onPrimary: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation: 5,
                                        ),
                                        onPressed: () {
                                          if (selectType!=null && selectSub!=null && nameController.text!=null) {
                                            if (_formKey.currentState.validate()) {
                                              events.doc(selectEv).update({
                                                "name": nameController.text,
                                                "description": descriptionController.text,
                                                'url': _url != null ? _url: url,
                                              }).then((_) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Изменено')));
                                                nameController.clear();
                                                selectType.clear();
                                                selectSub.clear();
                                                descriptionController.clear();
                                                _url = null;
                                              }).catchError((onError) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(content: Text(onError)));
                                              });
                                            }
                                          }
                                          else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Не изменено. название не может быть пустым')));
                                          }
                                          setState(() {
                                            //                                   _url = null;
                                          });},
                                        child: Text('Изменить'),
                                      ): Text(''),
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
                                                builder: (context) => ListEvents(title: "Список событий", subtype: selectSub)),
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

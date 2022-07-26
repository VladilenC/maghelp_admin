import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maghelp_add_act/List/accessories_act_list.dart';
import 'package:maghelp_add_act/List/acts_list.dart';
import 'List/acts_list original.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maghelp_add_act/List/pictures_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyAct extends StatefulWidget {
  MyAct({Key? key, this.user, this.acts, this.accessories}) : super(key: key);
  final user, acts, accessories;

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
  dynamic size = 0;
  final typeItems = [
    "Ритуал",
    "Заговор",
    "Приворот",
    "Оберег",
    "Талисман",
    "Народный рецепт",
    "Практический совет",
    "Методика симорон"
  ];
  CollectionReference acts = FirebaseFirestore.instance.collection("acts");
  final Stream<QuerySnapshot> events = FirebaseFirestore.instance
      .collection("events")
      .orderBy('name')
      .snapshots();
  var saved;
  var idAdd;
  var kol;
  var selectEmpty = false, selectBad = false;

  @override
  void initState() {
    super.initState();
    saved = 0;
    idAdd = '';
    acts.get().then((value) async {
      setState(() {
        kol = value.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
/*
    Future<void> updateItem(value) async {
      DocumentReference documentReferencer =
      acts.doc(value);

      Map<String, dynamic> data = <String, dynamic>{
        "uid": widget.user.uid,
        "user": widget.user.email,
        "date": DateFormat("dd-MM-yyyy H:m:s")
            .format(DateTime.now()),
        "datetime": DateTime.now()
      };

      await documentReferencer
          .update(data);
    }

acts.get().then((value) async {
  value.docs.forEach((element) async {
    await updateItem(element.id);
  });
});
*/
    /*
    acts.get().then((value) async {
      setState(() {
        kol = value.docs.length;
      });

        });
*/

    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  SizedBox(height: 10.0),
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
                            setState(() {
                              saved = 0;
                              idAdd = '';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Вводите новое действие')));
                            nameController.clear();
                            descriptionController.clear();
                            descriptionController2.clear();
                            descriptionController3.clear();
                            selectType = null;
                            selectEvent = null;
                          },
                          child: Text('Новое действие')),
                      Row(children: [
                        Icon(
                          Icons.check,
                          size: 25.0,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        DropdownButton(
                          items: typeItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (typeValue) {
                            setState(() {
                              selectType = typeValue;
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
                                    selectEvent = null;
                                    nameController.clear();
                                    descriptionController.clear();
                                    _url = null;
                                    descriptionController2.clear();
                                    _url2 = null;
                                    descriptionController3.clear();
                                    _url3 = null;
                                  });
                                },
                                icon: Icon(Icons.cancel),
                                color: Colors.red,
                              )
                            : Container()
                      ]),
                      Text(kol.toString())
                    ],
                  ),
                  SizedBox(height: 10.0),
                  StreamBuilder<QuerySnapshot>(
                      stream: events,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return SizedBox(
                              height: 35,
                              width: 0,
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              )));
                        else {
                          List<DropdownMenuItem> typeSubs = [];
                          final    values = snapshot.data!.docs.toList();
                          for (int i = 0; i < values.length; i++) {
                            DocumentSnapshot snap = values[i];
                            typeSubs.add(
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
                              Flexible(
                                child: DropdownButton<dynamic>(
                                  items: typeSubs,
                                  onChanged: (subValue) {
                                    setState(() {
                                      selectEvent = subValue;
                                    });
                                  },
                                  value: selectEvent,
                                  isExpanded: true,
                                  hint: Text(
                                    'Выберите событие',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                              selectEvent != null
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectEvent = null;
                                          nameController.clear();
                                          descriptionController.clear();
                                          _url = null;
                                          descriptionController2.clear();
                                          _url2 = null;
                                          descriptionController3.clear();
                                          _url3 = null;
                                        });
                                      },
                                      icon: Icon(Icons.cancel),
                                      color: Colors.red,
                                    )
                                  : Container()
                            ],
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
                      child: _url != null
                          ? CachedNetworkImage(
                              imageUrl: _url,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          //                 Image.network(_url)
                          : Text('Нет картинки', textAlign: TextAlign.center)),
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
                                        builder: (context) => ListPicture(
                                            title: "Выбор картинки", id: null)),
                                  );
                                  setState(() {
                                    _url = _url0['url'];
                                    if (_url == null) {
                                      _url = '';
                                    }
                                    //                _pic = _url0['pic'];
                                  });
                                })
                          ])),
                  TextFormField(
                    controller: descriptionController2,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание2',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: _url2 != null
                          ? CachedNetworkImage(
                              imageUrl: _url2,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          //                   Image.network(_url2)
                          : Text('Нет картинки', textAlign: TextAlign.center)),
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
                                        builder: (context) => ListPicture(
                                            title: "Выбор картинки", id: null)),
                                  );
                                  setState(() {
                                    _url2 = _url0['url'];
                                    if (_url2 == null) {
                                      _url2 = '';
                                    }
                                    //           _pic2 = _url0['pic'];
                                  });
                                })
                          ])),
                  TextFormField(
                    controller: descriptionController3,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание3',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: _url3 != null
                          ? CachedNetworkImage(
                              imageUrl: _url3,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          //                  Image.network(_url)
                          : Text('Нет картинки', textAlign: TextAlign.center)),
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
                                        builder: (context) => ListPicture(
                                            title: "Выбор картинки", id: null)),
                                  );
                                  setState(() {
                                    _url3 = _url0['url'];
                                    if (_url3 == null) {
                                      _url3 = '';
                                    }
                                    //     _pic3 = _url0['pic'];
                                  });
                                })
                          ])),
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
                          onPressed: () async {
                            if (selectType != null && selectEvent != null) {
                              if (_formKey.currentState!.validate()) {
                                if (idAdd == '') {
                                  await acts.add({
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
                                    "pic3": _pic3,
                                    "uid": widget.user.uid,
                                    "user": widget.user.email,
                                    "date": DateFormat("dd-MM-yyyy H:m:s")
                                        .format(DateTime.now()),
                                    "datetime": DateTime.now(),
                                    "badAcc": 0,
                                    "accessories": 0
                                  }).then((value) {
                                    setState(() {
                                      idAdd = value.id;
                                      saved = 1;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Добавлено')));
                                    //                          nameController.clear();
                                    //                          descriptionController.clear();
                                    //                          descriptionController2.clear();
                                    //                          descriptionController3.clear();
                                    //                          selectType = null;
                                    //                          selectEvent = null;
                                  }).catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(onError)));
                                  });
                                } else {
                                  await acts.doc(idAdd).set({
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
                                  }).then((value) {
                                    setState(() {
                                      saved = 1;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Сохранено')));
                                    //                          nameController.clear();
                                    //                          descriptionController.clear();
                                    //                          descriptionController2.clear();
                                    //                          descriptionController3.clear();
                                    //                          selectType = null;
                                    //                          selectEvent = null;
                                  }).catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(onError)));
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Не сохранено. Поля не могут быть пустыми')));
                              }
                            }
                          },
                          child: saved == 1
                              ? Text('Сохранить')
                              : Text('Добавить')),
                      saved == 1
                          ? ElevatedButton(
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
                                      builder: (context) => ListAccessoriesAct(
                                          title: "Аксессуары",
                                          id: idAdd,
                                          name: nameController.text,
                                          accessories: widget.accessories)),
                                );
                              },
                              child: Text('Аксессуары'),
                            )
                          : Container(),
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
                                builder: (context) => ListActsOriginal(
                                      title: "Список действий",
                                      event: selectEvent,
                                      acts: widget.acts,
                                      accessories: widget.accessories,
                                    )),
                          );
                        },
                        child: Text('Список'),
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
                                builder: (context) => ListActs(
                                      title: "Проверка",
                                      event: selectEvent,
                                      acts: widget.acts,
                                      accessories: widget.accessories,
                                    )),
                          );
                        },
                        child: Text('Проверка'),
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
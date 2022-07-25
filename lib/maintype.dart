import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'List/types_list.dart';
import 'List/images_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyType extends StatefulWidget {
  MyType({Key? key, this.types}) : super(key: key);
  final types;

  @override
  _MyTypeState createState() => _MyTypeState();
}

class _MyTypeState extends State<MyType> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference types = FirebaseFirestore.instance.collection("types");
  final Stream<QuerySnapshot> typeStream = FirebaseFirestore.instance.collection('types').orderBy('name').snapshots();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();

  var descriptionController1 = TextEditingController();
  var descriptionController2 = TextEditingController();
  var descriptionController3 = TextEditingController();
  var descriptionController4 = TextEditingController();
  var descriptionController5 = TextEditingController();
  var selectType, _url, url;
  var desItems, urlItems, nameItems, r1Items, r2Items, r3Items, r4Items, r5Items, idItems;

  @override
  void initState() {
    // initializeFlutterFire();
    super.initState();
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
                          desItems = [];
                          urlItems = [];
                          nameItems = [];
                          r1Items = [];
                          r2Items = [];
                          r3Items = [];
                          r4Items = [];
                          r5Items = [];
                          idItems = [];
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
                            snap['description'] != null
                                ? desItems.add(snap['description'])
                                : desItems.add('');
                            snap['url'] != null
                                ? urlItems.add(snap['url'])
                                : urlItems.add('');
                            snap['name'] != null
                                ? nameItems.add(snap['name'])
                                : nameItems.add('');
                            snap['r1'] != null
                                ? r1Items.add(snap['r1'])
                                : r1Items.add('');
                            snap['r2'] != null
                                ? r2Items.add(snap['r2'])
                                : r2Items.add('');
                            snap['r3'] != null
                                ? r3Items.add(snap['r3'])
                                : r3Items.add('');
                            snap['r4'] != null
                                ? r4Items.add(snap['r4'])
                                : r4Items.add('');
                            snap['r5'] != null
                                ? r5Items.add(snap['r5'])
                                : r5Items.add('');
                            idItems.add(snap.id);
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
                                    var _i = idItems.indexOf(typeValue);
                                    nameController.text = nameItems[_i];
                                    descriptionController.text = desItems[_i];
                                    descriptionController1.text = r1Items[_i];
                                    descriptionController2.text = r2Items[_i];
                                    descriptionController3.text = r3Items[_i];
                                    descriptionController4.text = r4Items[_i];
                                    descriptionController5.text = r5Items[_i];
                                    url = urlItems[_i];
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
                                          nameController.clear();
                                          descriptionController.clear();
                                          descriptionController1.clear();
                                          descriptionController2.clear();
                                          descriptionController3.clear();
                                          descriptionController4.clear();
                                          descriptionController5.clear();
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
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: descriptionController1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание для полезности 1',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: descriptionController2,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание для полезности 2',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: descriptionController3,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание для полезности 3',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: descriptionController4,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание для полезности 4',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: descriptionController5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Введите описание для полезности 5',
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
                          //                  Image.network(_url)
                          : (url != null
                              ? CachedNetworkImage(
                                  imageUrl: url,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.airport_shuttle),
                                )
                              //                  Image.network(url)
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
                      selectType == null
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                onPrimary: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                              onPressed: () {
                                if (nameController.text.trim() != '') {
                                  if (_formKey.currentState!.validate()) {
                                    types.doc().set({
                                      "name": nameController.text,
                                      "description": descriptionController.text,
                                      "r1": descriptionController1.text,
                                      "r2": descriptionController2.text,
                                      "r3": descriptionController3.text,
                                      "r4": descriptionController4.text,
                                      "r5": descriptionController5.text,
                                      "m1": 0,
                                      "m2": 0,
                                      "m3": 0,
                                      "m4": 0,
                                      "m5": 0,
                                      "m6": 0,
                                      "m7": 0,
                                      "m8": 0,
                                      "m9": 0,
                                      "m10": 0,
                                      "m11": 0,
                                      "m12": 0,
                                      "m13": 0,
                                      "m14": 0,
                                      "m15": 0,
                                      "m16": 0,
                                      "m17": 0,
                                      "m18": 0,
                                      "m19": 0,
                                      "m20": 0,
                                      "m21": 0,
                                      "m22": 0,
                                      "m23": 0,
                                      "m24": 0,
                                      "m25": 0,
                                      "m26": 0,
                                      "m27": 0,
                                      "m28": 0,
                                      "m29": 0,
                                      "m30": 0,
                                      'url': _url
                                    }).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Добавлено')));
                                      nameController.clear();
                                      selectType = null;
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
                                              'Не добавлено. Название не может быть пустым')));
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
                                if (selectType != null &&
                                    nameController.text.trim() != '') {
                                  if (_formKey.currentState!.validate()) {
                                    types.doc(selectType).update({
                                      "name": nameController.text,
                                      "description": descriptionController.text,
                                      "r1": descriptionController1.text,
                                      "r2": descriptionController2.text,
                                      "r3": descriptionController3.text,
                                      "r4": descriptionController4.text,
                                      "r5": descriptionController5.text,
                                      'url': _url != null ? _url : url,
                                    }).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Изменено')));
                                      setState(() {
                                        nameController.clear();
                                        selectType = null;
                                        descriptionController.clear();
                                        descriptionController1.clear();
                                        descriptionController2.clear();
                                        descriptionController3.clear();
                                        descriptionController4.clear();
                                        descriptionController5.clear();
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
                                              'Не изменено. Название не может быть пустым')));
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
                                builder: (context) =>
                                    ListTypes(title: "Список типов")),
                          );
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
  }
  */
}

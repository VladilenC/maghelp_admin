import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'List/types_list.dart';
import 'List/images_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyAdd extends StatefulWidget {
  MyAdd({Key? key, this.types}) : super(key: key);
  final types;

  @override
  _MyAddState createState() => _MyAddState();
}

class _MyAddState extends State<MyAdd> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference types = FirebaseFirestore.instance.collection("types");
  final Stream<QuerySnapshot> typeStream = FirebaseFirestore.instance.collection('types').snapshots();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var selectType, _url, url;
  var desItems, urlItems, nameItems, idItems;

  @override
  void initState() {
    // initializeFlutterFire();
    super.initState();

    types.get().then((value) {
      value.docs.forEach((element) {
        for (int i =0; i<6; i++) {
        addF(element.id,i);}
        print(element.id);
      });
    });
  }

 @override
  void addF(index,i) {
    types.doc(index).update({'r$i': ''});
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
                                      'url': _url != null ? _url : url,
                                    }).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Изменено')));
                                      setState(() {
                                        nameController.clear();
                                        selectType = null;
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

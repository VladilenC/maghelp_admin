import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maghelp_add_act/List/accessories_act_list.dart';
import 'package:flutter/material.dart';
import 'package:maghelp_add_act/List/pictures_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ActEdit1 extends StatefulWidget {
  ActEdit1(
      {Key? key,
      this.nom,
      this.id,
      this.name,
      this.type,
      this.event,
      this.description,
      this.url,
      this.description2,
      this.url2,
      this.description3,
      this.url3,
      this.title,
      this.accessories})
      : super(key: key);
  final dynamic title;
  final dynamic id;
  final dynamic nom;
  final dynamic name;
  final dynamic type;
  final dynamic event;
  final dynamic description;
  final dynamic description2;
  final dynamic description3;
  final dynamic url;
  final dynamic url2;
  final dynamic url3;
  final accessories;

  @override
  _ActEdit1 createState() => _ActEdit1();
}

class _ActEdit1 extends State<ActEdit1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ': ' + widget.id),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ActEdit(
                  nom: widget.nom,
                  id: widget.id,
                  name: widget.name,
                  type: widget.type,
                  event: widget.event,
                  description: widget.description,
                  description2: widget.description2,
                  description3: widget.description3,
                  url: widget.url,
                  url2: widget.url2,
                  url3: widget.url3,
                  title: widget.title,
                  accessories: widget.accessories),
            ]),
      )),
    );
  }
}

class ActEdit extends StatefulWidget {
  ActEdit(
      {Key? key,
      this.nom,
      this.id,
      this.name,
      this.type,
      this.event,
      this.description,
      this.url,
      this.description2,
      this.url2,
      this.description3,
      this.url3,
      this.title,
      this.accessories})
      : super(key: key);
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic type;
  final dynamic event;
  final dynamic description;
  final dynamic description2;
  final dynamic description3;
  final dynamic url;
  final dynamic url2;
  final dynamic url3;
  final dynamic title;
  final accessories;

  @override
  _ActEdit1State createState() => _ActEdit1State();
}

class _ActEdit1State extends State<ActEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final eventController = TextEditingController();
  final descriptionController = TextEditingController();
  final descriptionController2 = TextEditingController();
  final descriptionController3 = TextEditingController();
  var _url, _url2, _url3;
  CollectionReference events = FirebaseFirestore.instance.collection("acts");

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: widget.name);
    final _typeController = TextEditingController(text: widget.type);
    final _eventController = TextEditingController(text: widget.event);
    final _descriptionController =
        TextEditingController(text: widget.description);
    final _descriptionController2 =
        TextEditingController(text: widget.description2);
    final _descriptionController3 =
        TextEditingController(text: widget.description3);
    final _urlF = widget.url;
    final _urlF2 = widget.url2;
    final _urlF3 = widget.url3;
    _url == null ? _url = _urlF : _url = _url;
    _url2 == null ? _url2 = _urlF2 : _url2 = _url2;
    _url3 == null ? _url3 = _urlF3 : _url3 = _url3;
    return Form(
        key: _formKey2,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _typeController,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Тип",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Тип обязателен';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _eventController,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Событие",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Событие обязательно';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Название",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Описание",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Описание обязательно';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: _url != null
                  ? CachedNetworkImage(
                      imageUrl: _url,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  //           Image.network(_url)
                  : Text('Нет картинки')),
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
                          });
                        })
                  ])),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _descriptionController2,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Описание2",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: _url2 != null
                  ? CachedNetworkImage(
                      imageUrl: _url2,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Text('Нет картинки')),
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
                          });
                        })
                  ])),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _descriptionController3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Описание3",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: _url3 != null
                  ? CachedNetworkImage(
                      imageUrl: _url3,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Text('Нет картинки')),
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
                          });
                        })
                  ])),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.grey,
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (_formKey2.currentState!.validate()) {
                      events.doc(widget.id).update({
                        "name": _nameController.text,
                        "type": _typeController.text,
                        "event": _eventController.text,
                        "description": _descriptionController.text,
                        "url": _url,
                        "description2": _descriptionController2.text,
                        "url2": _url2,
                        "description3": _descriptionController3.text,
                        "url3": _url3,
                      }).then((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Сохранено')));
                        typeController.clear();
                        nameController.clear();
                        eventController.clear();
                        descriptionController.clear();
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                      });
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
                          builder: (context) => ListAccessoriesAct(
                              title: "Аксессуары",
                              id: widget.id,
                              name: widget.name,
                              accessories: widget.accessories)),
                    );
                  },
                  child: Text('Аксессуары'),
                ),
              ],
            ),
          ),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    nameController.dispose();
    typeController.dispose();
    eventController.dispose();
  }
}

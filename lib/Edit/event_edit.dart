import 'package:cloud_firestore/cloud_firestore.dart';
import '../List/images_list.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventEdit1 extends StatefulWidget {
  EventEdit1(
      {Key? key,
      this.nom,
      this.id,
      this.name,
      this.type,
      this.subtype,
      this.title,
      this.url})
      : super(key: key);
  final dynamic title;
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic type;
  final dynamic subtype;
  final dynamic url;

  @override
  _EventEdit1 createState() => _EventEdit1();
}

class _EventEdit1 extends State<EventEdit1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ': ' + widget.name),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Измените событие",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              EventEdit(
                  nom: widget.nom,
                  url: widget.url,
                  id: widget.id,
                  name: widget.name,
                  type: widget.type,
                  subtype: widget.subtype),
            ]),
      )),
    );
  }
}

class EventEdit extends StatefulWidget {
  EventEdit(
      {Key? key,
      this.nom,
      this.id,
      this.name,
      this.type,
      this.subtype,
      this.url})
      : super(key: key);
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic type;
  final dynamic subtype;
  final dynamic url;

  @override
  _EventEditState createState() => _EventEditState();
}

class _EventEditState extends State<EventEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  var _url;
  var _pic;
  var _nameController0;
  CollectionReference events = FirebaseFirestore.instance.collection("events");

  @override
  Widget build(BuildContext context) {
    final _nameController = _nameController0 != null
        ? _nameController0
        : TextEditingController(text: widget.name);

    final _typeController = TextEditingController(text: widget.type);
    final _subtypeController = TextEditingController(text: widget.subtype);

    return Form(
        key: _formKey2,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
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
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _subtypeController,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Подтип",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Подтип обязателен';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Название",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Название обязательно';
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
                  //             Image.network(_url)
                  : widget.url != null
                      ? CachedNetworkImage(
                          imageUrl: widget.url,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      //            Image.network(widget.url)
                      : Text('Нет картинки')),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Выбор картинки"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: () async {
                      var _url0 = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListImages(title: "Выбор картинки", id: null)),
                      );
                      setState(() {
                        _url = _url0['url'];
                        _pic = _url0['pic'];
                        _nameController0 = _nameController;
                      });
                    }),
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    shadowColor: Colors.grey,
                    elevation: 5,
                  ),
                  onPressed: () {
                    setState(() {});
                    if (_formKey2.currentState!.validate()) {
                      events.doc(widget.id).update({
                        "name": _nameController.text,
                        "url": _url != null ? _url : widget.url,
                        "pic": _url != null ? _pic : null
                      }).then((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Сохранено')));
                        typeController.clear();
                        nameController.clear();
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Сохранить'),
                ),
              ],
            ),
          ),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    typeController.dispose();
    //   subtypeController.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:image_picker_web/image_picker_web.dart';


class AccessoryEdit1 extends StatefulWidget {
  AccessoryEdit1({Key key, this.nom, this.id, this.name, this.title, this.url}) : super(key: key);
  final dynamic title;
  final dynamic  nom;
  final dynamic id;
  final dynamic name;
  final dynamic url;

  @override
  _AccessoryEdit1 createState() => _AccessoryEdit1();
}

class _AccessoryEdit1 extends State<AccessoryEdit1> {
  final accessory = FirebaseFirestore.instance.collection("accessories");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title+': '+widget.name),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Измените аксессуар",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              AccessoryEdit(nom: widget.nom, url: widget.url, id: widget.id, name: widget.name),
            ]),
      )),
    );
  }
}

class AccessoryEdit extends StatefulWidget {
  AccessoryEdit({Key key, this.nom, this.id, this.name, this.url}) : super(key: key);
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic url;

  @override
  _AccessoryEditState createState() => _AccessoryEditState();
}

class _AccessoryEditState extends State<AccessoryEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  var _url;
  var _nameController0;
  Image _web2;
  Uint8List _uiWeb;
  MediaInfo _media;


  @override
  Widget build(BuildContext context) {
    CollectionReference  accessories = FirebaseFirestore.instance.collection("accessories");

    final _nameController = _nameController0!=null ? _nameController0 : TextEditingController(text: widget.name);

    return Form(
        key: _formKey2,
    child: SingleChildScrollView(
            child: Column(children: <Widget>[
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
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Название обязательно';
                    }
                    return null;
                  },
                ),
              ),
            Padding(
            padding: EdgeInsets.all(5.0),
              child: _url!=null ? Image.network(_url) : widget.url!=null ? Image.network(widget.url):Text('Нет картинки')),
             Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /*
                  ElevatedButton(
                      child: Text("Выбор картинки"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        onPrimary: Colors.white,
                        shadowColor: Colors.grey,
                        elevation: 5,
                      ),
                      onPressed: ()  {

                        getImage();

                      }

                      ),
                  */
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {

                      });
                      if (_formKey2.currentState.validate()) {
                        dynamic i = int.parse(widget.nom)+1;
;                        accessories.doc(widget.id).update({
                          "name": _nameController.text,
                          "url": _url!=null ? _url : widget.url,
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Сохранено')));
                          nameController.clear();
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });

                      }
                      Navigator.pop(
                        context
                      );
                    },
                    child: Text('Сохранить'),
                  ),
                ],
              ),

          ),
        ])));
  }

  Future getImage() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;

    setState(() {
      _media = mediaInfo;
      _uiWeb = mediaInfo.data;
      //     _web = image;
      _web2 = Image.memory(mediaInfo.data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/events_list.dart';
import 'package:flutter/material.dart';


class EventEdit1 extends StatefulWidget {
  EventEdit1({Key key, this.nom, this.name, this.type, this.subtype, this.title}) : super(key: key);
  final dynamic title;
  final dynamic  nom;
  final dynamic name;
  final dynamic type;
  final dynamic subtype;

  @override
  _EventEdit1 createState() => _EventEdit1();
}

class _EventEdit1 extends State<EventEdit1> {
  final events = FirebaseFirestore.instance.collection("events");
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
              Text("Измените событие",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              EventEdit(nom: widget.nom, name: widget.name, type: widget.type, subtype: widget.subtype),
            ]),
      )),
    );
  }
}

class EventEdit extends StatefulWidget {
  EventEdit({Key key, this.nom, this.name, this.type, this.subtype}) : super(key: key);
  final dynamic nom;
  final dynamic name;
  final dynamic type;
  final dynamic subtype;



  @override
  _EventEditState createState() => _EventEditState();
}

class _EventEditState extends State<EventEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final subtypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference  events = FirebaseFirestore.instance.collection("events");

    final _nameController = TextEditingController(text: widget.name);
    final _typeController = TextEditingController(text: widget.type);
    final _subtypeController = TextEditingController(text: widget.subtype);

    return Form(
        key: _formKey2,
    child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _typeController,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Тип",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Тип обязателен';
                }
                return null;
              },
            ),
          ),
              Padding(
                padding: EdgeInsets.all(20.0),
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
                    if (value.isEmpty) {
                      return 'Подтип обязателен';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
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
              padding: EdgeInsets.all(20.0),
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
                      if (_formKey2.currentState.validate()) {
                        dynamic i = int.parse(widget.nom)+1
;                        events.doc(i.toString()).update({
                          "name": _nameController.text,
                          "type": _typeController.text,
                          "subtype": _subtypeController.text
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Сохранено')));
                          typeController.clear();
                          nameController.clear();
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
                      primary: Colors.amber,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListEvents(title: "Home Page")),
                      );
                    },
                    child: Text('Отмена'),
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
    subtypeController.dispose();
  }
}

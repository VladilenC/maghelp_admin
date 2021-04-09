import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/home.dart';
import 'package:firebase_database_tutorial/events_list.dart';
import 'package:flutter/material.dart';


class Actedit extends StatefulWidget {
  Actedit({Key key, this.nomer, this.name, this.type, this.event, this.description, this.title}) : super(key: key);
  final String title;
  final String nomer;
  final String name;
  final String type;
  final String event;
  final String description;

  @override
  _Actedit createState() => _Actedit();
}

class _Actedit extends State<Actedit> {
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
              EventEdit(nomer: widget.nomer, name: widget.name, type: widget.type, subtype: widget.description),
            ]),
      )),
    );
  }
}

class EventEdit extends StatefulWidget {
  EventEdit({Key key, this.nomer, this.name, this.type, this.event, this.description}) : super(key: key);
  final dynamic nomer;
  final dynamic name;
  final dynamic type;
  final dynamic event;
  final dynamic description;



  @override
  _ActEditState createState() => _ActEditState();
}

class _ActEditState extends State<EventEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final listOfPets = ["Cats", "Dogs", "Rabbits"];
  String dropdownValue = 'Cats';
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final subtypeController = TextEditingController();
  final ageController = TextEditingController();
  var selectType, selectEvent;

  @override
  Widget build(BuildContext context) {
    CollectionReference  events = FirebaseFirestore.instance.collection("acts");

    var order = int.parse(widget.nomer) + 1;

    final _nameController = TextEditingController(text: widget.name);
    final _descriptionController = TextEditingController(text: widget.description);


    return Form(
        key: _formKey2,
    child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: "Введите тип",
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
                  decoration: InputDecoration(
                    labelText: "Введите подтип",
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
                    labelText: "Введите название",
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
                  RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      if (_formKey2.currentState.validate()) {
                        dynamic i = int.parse(widget.nomer)+1
;                        events.doc(i.toString()).update({
                          "name": _nameController.text,
                          "type": _typeController.text,
                          "subtype": _subtypeController.text
                          //"type": dropdownValue
                        }).then((_) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Successfully Added')));
                          typeController.clear();
                          nameController.clear();
                        }).catchError((onError) {
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });
                      }
                    },
                    child: Text('Сохранить'),
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home_events(title: "Home Page")),
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
    ageController.dispose();
    nameController.dispose();
    typeController.dispose();
    subtypeController.dispose();
  }
}

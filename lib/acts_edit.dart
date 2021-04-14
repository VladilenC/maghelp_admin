import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/events_list.dart';
import 'package:flutter/material.dart';


class ActEdit extends StatefulWidget {
  ActEdit({Key key,  this.nom,  this.name,  this.type,  this.event,  this.description,  this.title}) : super(key: key);
  final dynamic title;
  final dynamic nom;
  final dynamic name;
  final dynamic type;
  final dynamic event;
  final dynamic description;

  @override
  _ActEdit createState() => _ActEdit();
}

class _ActEdit extends State<ActEdit> {
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
              EventEdit(nom: widget.nom, name: widget.name, type: widget.type, event: widget.event, description: widget.description),
            ]),
      )),
    );
  }
}

class EventEdit extends StatefulWidget {
  EventEdit({Key key, this.nom, this.name, this.type, this.event, this.description}) : super(key: key);
  final dynamic nom;
  final dynamic name;
  final dynamic type;
  final dynamic event;
  final dynamic description;



  @override
  _ActEditState createState() => _ActEditState();
}

class _ActEditState extends State<EventEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final eventController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference  events = FirebaseFirestore.instance.collection("acts");

    final _nameController = TextEditingController(text: widget.name);
    final _typeController = TextEditingController(text: widget.type);
    final _eventController = TextEditingController(text: widget.event);
    final _descriptionController = TextEditingController(text: widget.description);


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
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
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
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 13,
                  decoration: InputDecoration(
                    labelText: "Описание",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Описание обязательно';
                    }
                    return null;
                  },
                ),
              ),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
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
                      if (_formKey2.currentState.validate()) {
                        dynamic i = int.parse(widget.nom)+1
;                        events.doc(i.toString()).update({
                          "name": _nameController.text,
                          "type": _typeController.text,
                          "event": _eventController.text,
                          "description": _descriptionController.text
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Сохранено')));
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
    descriptionController.dispose();
    nameController.dispose();
    typeController.dispose();
    eventController.dispose();
  }
}

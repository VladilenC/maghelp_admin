import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/types_list.dart';
import 'package:firebase_database_tutorial/types_edit.dart';
import 'package:flutter/material.dart';



class MyTypes extends StatefulWidget {
  MyTypes({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyTypesState createState() => _MyTypesState();
}

class _MyTypesState extends State<MyTypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Введите тип",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              RegisterType(),
            ]),
      )),
    );
  }
}

class RegisterType extends StatefulWidget {
  RegisterType({Key key}) : super(key: key);

  @override
  _RegisterTypeState createState() => _RegisterTypeState();
}

class _RegisterTypeState extends State<RegisterType> {
  final _formKey = GlobalKey<FormState>();
  final listOfPets = ["Cats", "Dogs", "Rabbits"];
  String dropdownValue = 'Cats';
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final subtypeController = TextEditingController();
  final ageController = TextEditingController();

  List<String> listTypes = [];



  @override
  Widget build(BuildContext context) {
    CollectionReference  events = FirebaseFirestore.instance.collection("types");



  typesInstance.collection('types').get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      listTypes.add(element.data()['type']);

    });      print(listTypes);
  });
   // String dropdownValue = listTypes[0];
print('1111');
  print(listTypes);
  print(listOfPets);



    return


   Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: DropdownButtonFormField(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        decoration: InputDecoration(
                          labelText: "Выберите тип",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        items: listTypes.map((String value) {
                        return new DropdownMenuItem<String>(
                            value: value,
                          child: new Text(value),
                        );
                        }).toList(),
                        onChanged: (String newvalue) {
                          setState(() {
                            dropdownValue = newvalue;
                          });
                        },
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
                        controller: subtypeController,
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
                        controller: nameController,
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
                              if (_formKey.currentState.validate()) {
                                events.doc('5').set({
                                  "name": nameController.text,
                                  //"type": typeController.text,
                                  "subtype": subtypeController.text,
                                 // "type": dropdownValue
                                }).then((_) {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Добавлено')));
                                  ageController.clear();
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
                              print('11111');

print( listTypes );
print('2222');

                            },
                            child: Text('Список'),
                          ),
                        ],
                      ),

                    ),
                  ]
                  )
              )
          );


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

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/mainevent.dart';
import 'package:firebase_database_tutorial/maintype.dart';
import 'package:flutter/material.dart';



class MyEventsTop extends StatefulWidget {
  MyEventsTop({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyEventsTopState createState() => _MyEventsTopState();
}

class _MyEventsTopState extends State<MyEventsTop> {
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
              Text("Введите событие",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              RegisterEvent(),
            ]),
      )),
    );
  }
}

class RegisterEvent extends StatefulWidget {
  RegisterEvent({Key key}) : super(key: key);

  @override
  _RegisterEventState createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  //final _formKey = GlobalKey<FormState>();
  final listOfPets = ["Cats", "Dogs", "Rabbits"];
  String dropdownValue = 'Cats';
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final subtypeController = TextEditingController();
  final ageController = TextEditingController();
  var _currentPage = 0;
  var _pages = [
 //  MyEvents(title: '1111'),
   //MyTypes(title: '2222'),
    Text('11111'),
   // Text('22222')
  ];


  @override
  Widget build(BuildContext context) {
    CollectionReference  events = FirebaseFirestore.instance.collection("events");

    return Center( child: SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,

    children: [
    _pages.elementAt(_currentPage),
      BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.announcement),
                              title: Text('Событие')),
      BottomNavigationBarItem(icon: Icon(Icons.cake),
                              title: Text('Тип'))
      ],
        currentIndex: _currentPage,
        fixedColor: Colors.blue,
        onTap: (int inIndex) {
      setState(() {
        _currentPage = inIndex;
      });
        },
    )])

    )) ;

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

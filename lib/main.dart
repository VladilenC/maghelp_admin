import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database_tutorial/home.dart';
import 'package:firebase_database_tutorial/events_list.dart';
import 'package:firebase_database_tutorial/mainevent.dart';
import 'package:firebase_database_tutorial/mainact.dart';
import 'package:firebase_database_tutorial/maintype.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'События',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(title: Text('Магическая помощь'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Действия',),
              Tab(text: 'События',),
           //   Tab(text: 'Типы')
            ],
          ),),
          body: TabBarView(
            children: [
              MyAct(),
              MyEvent(),
           //   MyTypes(title: 'Типы')
            ],
          ),
        ),
      )
      );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              MyEvent(),
            ]),
      )),
    );
  }
}


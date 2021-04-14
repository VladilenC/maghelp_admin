
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database_tutorial/mainevent.dart';
import 'package:firebase_database_tutorial/mainact.dart';
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


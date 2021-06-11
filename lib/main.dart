
import 'package:firebase_core/firebase_core.dart';
import 'package:maghelp_add_act/mainsubtype.dart';
import 'package:maghelp_add_act/mainevent.dart';
import 'package:maghelp_add_act/mainact.dart';
import 'package:maghelp_add_act/mainimage.dart';
import 'package:maghelp_add_act/mainimageweb.dart';
import 'package:maghelp_add_act/mainimageweb2.dart';
import 'package:maghelp_add_act/mainimageweb3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maghelp_add_act/maintype.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  int ww1;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return Text('Error');
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return
        SizedBox(
            height: 36,
            width: 16,
            child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                )
            )
        );
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'События',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DefaultTabController(
          length: 7,
          child: Scaffold(
            appBar: AppBar(title: Text('Магическая помощь'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Типы'),
                  Tab(text: 'Подтипы'),
                  Tab(text: 'События'),
                  Tab(text: 'Действия'),
                  Tab(text: 'Картинки'),
                  Tab(text: 'Картинки в тексте'),
                  Tab(text: 'Аксессуары')
                  //   Tab(text: 'Типы')
                ],
              ),),
            body: TabBarView(
              children: [
                MyType(),
                MySubType(),
                MyEvent(),
                MyAct(),
                MyPic(),
                MyPic2(),
                MyPic3()
              ],
            ),
          ),
        )
    );

  }
}
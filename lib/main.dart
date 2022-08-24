import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Widgets/auth_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        _initialized = true;
      });
    } catch (e) {
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

    if (_error) {
      return Text('Error');
    }

    if (!_initialized) {
      return SizedBox(
          height: 36,
          width: 16,
          child: Center(
              child: CircularProgressIndicator(
            strokeWidth: 1.5,
          )));
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maghelp',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ru', 'RU'),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthDialog());

  }
}

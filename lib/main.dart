import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'Widgets/auth_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main() async {
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

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
   //   await Firebase.initializeApp();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        _initialized = true;
      });
    } catch (e) {
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

    if (_error) {
      return Text('Error');
    }


    // Show a loader until FlutterFire is initialized
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
          // 'en' is the language code. We could optionally provide a
          // a country code as the second param, e.g.
          // Locale('en', 'US'). If we do that, we may want to
          // provide an additional app_en_US.arb file for
          // region-specific translations.
          //  const Locale('en', ''),
          const Locale('ru', 'RU'),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthDialog());

    //App_Menu());
  }
}

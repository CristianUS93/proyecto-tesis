import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tesis_app/pages/login_page.dart';
import 'package:flutter_tesis_app/pages/home_page.dart';
import 'package:flutter_tesis_app/utils/loading_screen.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.yellow[700],
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
        return snapshot.hasError
            ? Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            )
            : (snapshot.connectionState == ConnectionState.done)
            ? StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User user = snapshot.data;
                    if (user == null) {
                      return LoginPage();
                    } else {
                      return HomePage();
                    }
                  }
                  return LoadingScreen();
                },
              )
            : LoadingScreen();
      }
    );
  }
}

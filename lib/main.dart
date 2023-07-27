import 'package:flutter/material.dart';
import 'package:billshorts_webapp/pages/home.dart';
import 'package:billshorts_webapp/pages/loading.dart';
import 'package:billshorts_webapp/pages/hyperlink.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';

// Method to initialize Firebase
Future<void> initializeFlutterFire() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyA0s4qgRUfb3W3iEwTlMMal6-XAau8TSzM",
        appId: "1:762455748653:web:27fd9bf0be6c67a9e588a4",
        messagingSenderId: "762455748653",
        projectId: "bill-shorts")
  ); // Initialize Firebase
}

void main() async {
  // Call the Firebase initialization method before runApp
  await initializeFlutterFire();
  setPathUrlStrategy();

  runApp(MaterialApp(
    theme:ThemeData(fontFamily: "Roboto"),
    initialRoute: "/",
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/hyperlink': (context) => HyperlinkPage(
        destinationUrl: '',
      ),
    },
  ));
}

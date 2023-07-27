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
    options: FirebaseOptions(apiKey: "Use your own key",
        appId: "",
        messagingSenderId: "",
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

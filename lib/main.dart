import 'package:billshorts_webapp/pages/stocks.dart';
import 'package:flutter/material.dart';
import 'package:billshorts_webapp/pages/home.dart';
import 'package:billshorts_webapp/pages/loading.dart';
import 'package:billshorts_webapp/pages/hyperlink.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:billshorts_webapp/pages/about.dart';
import 'package:billshorts_webapp/pages/justtitles.dart';
import 'package:billshorts_webapp/pages/literature.dart';

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

class Routes {
  static const loading = '/';
  static const home = '/home';
  static const hyperlink = '/hyperlink';
  static const stocks = '/stocks';
  static const about = '/about';
  static const justTitles = '/justTitles';
  static const literature = '/literature';
}

void main() async {
  // Call the Firebase initialization method before runApp
  await initializeFlutterFire();
  setPathUrlStrategy();

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: "Roboto", scaffoldBackgroundColor: Color(0xFFf9f7f4)),
    initialRoute: Routes.loading, // Use the route name from Routes class
    routes: {
      Routes.loading: (context) => Loading(),
      Routes.home: (context) => Home(),
      Routes.hyperlink: (context) => HyperlinkPage(destinationUrl: ''),
      Routes.stocks: (context) => StockListScreen(),
      Routes.about: (context) => AboutPage(),
      Routes.justTitles: (context) => JustTitlesPage(),
      Routes.literature: (context) => LiteraturePage(),
    },
  ));
}
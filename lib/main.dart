import 'package:flutter/material.dart';
import 'package:app_votos/pages/BallotPage.dart';
import 'package:app_votos/pages/LoginPage.dart';
import 'package:app_votos/pages/ValidatePage.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      title: 'Voto electrónico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/ballot': (context) => BallotPage(),
        '/validate': (context) => ValidatePage(),
      },
    );
  }
}

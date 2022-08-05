import 'package:d_smarket/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:d_smarket/pages/homePage.dart';

void main(List<String> args) {
  runApp(const d_smarket());
}

class d_smarket extends StatelessWidget {
  const d_smarket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "d_smarket",
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Roboto Condensed',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: DSmarket.loginRoute,
      routes: {
        DSmarket.loginRoute: (context) => const LoginPage(),
        DSmarket.homeRoute: (context) => const LoginPage(),
        DSmarket.profileRoute: (context) => const LoginPage(),
        DSmarket.jobsRoute: (context) => const LoginPage(),
        DSmarket.marketplaceRoute: (context) => const LoginPage(),
      },
    );
  }
}

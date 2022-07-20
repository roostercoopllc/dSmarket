import 'package:flutter/material.dart';
import 'package:gigme/utils/routes.dart';
import 'package:gigme/pages/login_page.dart';

void main(List<String> args) {
  runApp(const GigMe());
}

class GigMe extends StatelessWidget {
  const GigMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GigMe",
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
      initialRoute: GigMeRoutes.loginRoute,
      routes: {
        GigMeRoutes.loginRoute: (context) => const LoginPage(),
        GigMeRoutes.homeRoute: (context) => const LoginPage(),
        GigMeRoutes.profileRoute: (context) => const LoginPage(),
        GigMeRoutes.jobsRoute: (context) => const LoginPage(),
        GigMeRoutes.marketplaceRoute: (context) => const LoginPage(),
      },
    );
  }
}

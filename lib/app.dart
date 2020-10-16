import 'package:covidviewerflutter/pages/home_page.dart';
import 'package:covidviewerflutter/viewmodel/covid_home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Covid World Stats'),
        ),
        body: ChangeNotifierProvider(
          create: (context) => CovidHomeViewModel(),
          child: HomePage(),
        ),
      ),
    );
  }
}

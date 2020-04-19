import 'package:covidviewerflutter/pages/home_page.dart';
import 'package:covidviewerflutter/viewmodel/covid_home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoViewer',
      home: ChangeNotifierProvider(
        create: (context) => CovidHomeViewModel(),
        child: HomePage(),
      ),
    );
  }
}

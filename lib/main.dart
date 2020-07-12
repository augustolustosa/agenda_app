
import 'package:agenda_app/helpers/contact_helper.dart';
import 'package:agenda_app/ui/contact_page.dart';
import 'package:agenda_app/ui/home_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App de Agenda",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


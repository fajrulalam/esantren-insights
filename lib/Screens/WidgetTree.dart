// import 'package:esantren_v1/Services/Authentication.dart';
// import 'package:esantren_v1/Classes/CurrentUserClass.dart';
// import 'package:esantren_v1/Objects/CurrentUserObject.dart';
// import 'package:esantren_v1/Screens/HomePage.dart';
// import 'package:esantren_v1/Screens/LoginPage.dart';
import 'package:flutter/material.dart';

import '../Services/Authntication.dart';
import 'HomePage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);
  static const String id = 'widget-tree';

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  // Future<CurrentUserObject> userDetail = CurrentUserClass().getUserDetail();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          return HomePage();
          // if (snapshot.hasData) {
          //   // return HomePage('Home');
          // } else {
          //   // return LoginScreen();
          // }
        });
  }
}

import 'package:esantren_insights_v1/Services/Authentication.dart';
import 'package:esantren_insights_v1/Classes/CurrentUserClass.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Screens/HomePage.dart';
import 'package:esantren_insights_v1/Screens/LoginPage.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);
  static const String id = 'widget-tree';

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('user is logged in');
          return FutureBuilder(
            future: checkIfUserIsVerified(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              //check if the snapshot contains the value true
              if (snapshot.hasData && snapshot.data == true) {
                return HomePage();
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else {
          print('user is not logged in');
          return LoginScreen();
        }
      },
    );
  }

  Future<bool> checkIfUserIsVerified() async {
    print("getting user detail");
    CurrentUserObject userDetail = await CurrentUserClass().getUserDetail();
    print(userDetail.role);
    if (userDetail.role == 'Admin' || userDetail.role == 'Asrama') {
      return true;
    } else {
      return false;
    }
  }
}

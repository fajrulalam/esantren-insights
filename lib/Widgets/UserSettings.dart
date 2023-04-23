import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/ProfilAsrama.dart';
import '../Screens/PengaturanAkun_Edit.dart';
import '../Services/CustomPageRouteAnimation.dart';

class UserSettings extends StatelessWidget {
  String setting;
  String currentData;
  String uid;
  final Function(String) notifyParent;
  bool isLocked;

  UserSettings(this.setting, this.currentData, this.uid, this.isLocked,
      this.notifyParent);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1),
        Material(
          child: InkWell(
            onTap: () {
              if (isLocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.deepOrangeAccent.withOpacity(1),
                    duration: Duration(milliseconds: 1000),
                    content: Text('Hubungi Admin untuk merubah ini',
                        style: GoogleFonts.poppins()),
                  ),
                );
                return;
              }
              Navigator.of(context).push(CustomPageRoute(
                  child: EditSetting(setting, currentData, uid, notifyParent)));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        setting,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Text(
                        currentData,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    child: isLocked
                        ? Icon(Icons.lock, size: 12)
                        : Icon(Icons.keyboard_arrow_right, size: 18),
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}

import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Screens/ProfilAsrama.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/CustomPageRouteAnimation.dart';
import 'PengaturanAkun_Edit.dart';

class SettingAsrama extends StatelessWidget {
  final CurrentUserObject userObject;

  const SettingAsrama({Key? key, required this.userObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://instagram.fsub8-2.fna.fbcdn.net/v/t51.2885-15/336938993_651619936974045_8726345547016895210_n.jpg?stp=dst-jpg_e35&_nc_ht=instagram.fsub8-2.fna.fbcdn.net&_nc_cat=109&_nc_ohc=0onokId5XzoAX8_if_V&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA2MzQzNTg2MTQ0Njg5Njg2NA%3D%3D.2-ccb7-5&oh=00_AfCWOlsz42xclKRz_eLZs8DocYoCTWlTCC2SJkqGSYidMA&oe=64464F79&_nc_sid=1527a3',
      'https://firebasestorage.googleapis.com/v0/b/e-santren.appspot.com/o/fotoAsrama%2FDU15_AlFalah%2F93761784_219180412645238_7880146869132381624_n.jpg?alt=media&token=06adddac-9d6b-4bdd-b94f-db915ffa13b2',
      'https://firebasestorage.googleapis.com/v0/b/e-santren.appspot.com/o/fotoAsrama%2FDU15_AlFalah%2F119882119_763492927557577_1523352540989159613_n.jpg?alt=media&token=346298b2-6bb8-4022-9af4-2211283fd099',
      'https://firebasestorage.googleapis.com/v0/b/e-santren.appspot.com/o/fotoAsrama%2FDU15_AlFalah%2F187651795_311304787296674_4376420471911140793_n.jpg?alt=media&token=d3658d7c-dbff-414c-bc1f-f71ad8c1ccec'
    ];
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
            //make an image carousel that the user can swipe through. the images is from a network image in images
            children: [
              //Text for the asrama name

              Container(
                height: 200,
                child: PageView.builder(
                  //give indicator that the user can swipe
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  children: [
                    Divider(height: 1),
                    Material(
                      child: InkWell(
                        onTap: () {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     backgroundColor:
                          //         Colors.deepOrangeAccent.withOpacity(1),
                          //     duration: Duration(milliseconds: 1000),
                          //     content: Text('Hubungi Admin untuk merubah ini',
                          //         style: GoogleFonts.poppins()),
                          //   ),
                          // );

                          Navigator.of(context).push(CustomPageRoute(
                              child: ProfilAsrama(
                            currentUserObject: userObject,
                          )));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  //icon of user setting
                                  child: Icon(Icons.settings,
                                      size: 20, color: Colors.black38),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Text(
                                    'Edit Profil Akun Asrama',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 20,
                                  child: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 12))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Divider(height: 1),
                    Material(
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.deepOrangeAccent.withOpacity(1),
                              duration: Duration(milliseconds: 1000),
                              content: Text('Hubungi Admin untuk merubah ini',
                                  style: GoogleFonts.poppins()),
                            ),
                          );

                          Navigator.of(context).push(CustomPageRoute(
                              child: EditSetting(
                                  'setting', 'currentData', 'uid', () {})));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  //icon of user setting
                                  child: Icon(Icons.payments,
                                      size: 20, color: Colors.black38),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Text(
                                    'Buat Invoice Baru',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 20,
                                  child: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 12))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Divider(height: 1),
                    Material(
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.deepOrangeAccent.withOpacity(1),
                              duration: Duration(milliseconds: 1000),
                              content: Text('Hubungi Admin untuk merubah ini',
                                  style: GoogleFonts.poppins()),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  //icon of user setting
                                  child: Icon(Icons.stacked_line_chart_rounded,
                                      size: 20, color: Colors.black38),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Text(
                                    'Mulai Tahun Ajaran Baru',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 20,
                                  child: Icon(Icons.lock_outline, size: 12))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Divider(height: 1),
                    Material(
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.deepOrangeAccent.withOpacity(1),
                              duration: Duration(milliseconds: 1000),
                              content: Text('Hubungi Admin untuk merubah ini',
                                  style: GoogleFonts.poppins()),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  //icon of user setting
                                  child: Icon(Icons.add_business,
                                      size: 20, color: Colors.black38),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Text(
                                    'Tambah Kelas',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 20,
                                  child: Icon(Icons.lock_outline, size: 12))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              ),
            ]));
  }
}

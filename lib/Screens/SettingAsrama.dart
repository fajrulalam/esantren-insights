import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/AsramaObject.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Screens/ProfilAsrama.dart';
import 'package:esantren_insights_v1/Services/UpdateEntireDocuments.dart';
import 'package:esantren_insights_v1/Widgets/LoaderWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/Authentication.dart';
import '../Services/CustomPageRouteAnimation.dart';
import 'InvoiceBaru.dart';
import 'PengaturanAkun_Edit.dart';

class SettingAsrama extends StatelessWidget {
  final CurrentUserObject userObject;
  final AsramaObject asramaDetail;

  const SettingAsrama(
      {Key? key, required this.userObject, required this.asramaDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> images = asramaDetail.listFoto;

    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          Navigator.of(context).push(CustomPageRoute(
                              child: ProfilAsrama(
                            currentUserObject: userObject,
                            asramaDetail: asramaDetail,
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
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(CustomPageRoute(
                                child: InvoiceBaru(
                                    'Invoice Baru', '', userObject,
                                    (String namaInvoice, int nominal) async {
                              Navigator.pop(context);
                              LoaderWidget.showLoader(context);
                              int jumlahSantriAktif =
                                  await UpdateEntireDocuments
                                      .tambahInvoiceBaru();
                              Map<String, dynamic> data = {
                                'jumlahPembayar': 0,
                                'jumlahSantriAktif': jumlahSantriAktif,
                                'kodeAsrama': userObject.kodeAsrama,
                                'nominal': nominal,
                                'tglInvoice': DateTime.now()
                              };
                              await FirebaseFirestore.instance
                                  .collection('InvoiceCollection')
                                  .doc(namaInvoice)
                                  .set(data);
                              Navigator.pop(context);
                            })));
                          },
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    SizedBox(height: 24),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await Auth().signOut();
                              // SignOut successful, navigate to the home screen
                              Navigator.pushReplacementNamed(context, '/home');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          },
                          child: Text('Sign-Out')),
                    )
                  ],
                ),
              ),
            ]));
  }
}

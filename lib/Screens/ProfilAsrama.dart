import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/Authentication.dart';
import '../Services/StorageServices.dart';
import '../Widgets/UserSettings.dart';

class ProfilAsrama extends StatefulWidget {
  final CurrentUserObject currentUserObject;

  const ProfilAsrama({Key? key, required this.currentUserObject})
      : super(key: key);

  @override
  State<ProfilAsrama> createState() =>
      _ProfilAsramaState(currentUserObject: currentUserObject);
}

class _ProfilAsramaState extends State<ProfilAsrama> {
  final CurrentUserObject currentUserObject;
  String? imagepath;

  _ProfilAsramaState({required this.currentUserObject});

  Future<void> _signOut() async {
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
  }

  @override
  Widget build(BuildContext context) {
    imagepath = currentUserObject.fotoProfil;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Asrama'),
        leading: BackButton(
          color: Colors.grey,
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(), flex: 1),
                SizedBox(
                  width: 104,
                  child: Stack(
                    children: [
                      imagepath != ""
                          ? Center(
                              child: CircleAvatar(
                                radius: 52,
                                backgroundColor: Colors.black87,
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(imagepath!)),
                              ),
                            )
                          : Center(
                              child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: Colors.black87,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                    // backgroundImage: NetworkImage(imagepath)),
                                  )),
                            ),
                      Positioned(
                        bottom: 0,
                        right: -4,
                        child: GestureDetector(
                          onTap: () async {
                            XFile? file = await getImage();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 16),
                                      Text("Menyimpan...",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700))
                                    ],
                                  ),
                                );
                              },
                            );

                            if (imagepath != "") {
                              StorageServices.deletePreviousImage(widget
                                  .currentUserObject.fotoProfil
                                  .toString());
                            }

                            imagepath =
                                await StorageServices.uploadProfileImage(
                                    file!, widget.currentUserObject.uid!);

                            () {}();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 10.5,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.black87,
                                radius: 10,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container(), flex: 1),
              ],
            ),
            SizedBox(height: 20),
            UserSettings('Nama Asrama', widget.currentUserObject.namaLengkap!,
                widget.currentUserObject.uid!, false, () {}),
            UserSettings('Pengasuh', widget.currentUserObject.namaPanggilan!,
                widget.currentUserObject.uid!, false, () {}),
            UserSettings('Program', widget.currentUserObject.kotaAsal!,
                widget.currentUserObject.uid!, false, () {}),
            UserSettings('Profil Singkat', widget.currentUserObject.tglLahir!,
                widget.currentUserObject.uid!, false, () {}),
            UserSettings(
                'Mukim',
                widget.currentUserObject.mukim == true ? 'Iya' : 'Tidak',
                widget.currentUserObject.uid!,
                true,
                () {}),
            UserSettings('Peran User', widget.currentUserObject.role!,
                widget.currentUserObject.uid!, true, () {}),
            SizedBox(height: 32),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                  onPressed: () {
                    _signOut();
                  },
                  child: Text('Sign-Out')),
            )
          ],
        ),
      ),
    );
  }

  Future<XFile?> getImage() async {
    ImagePicker picker = ImagePicker();
    // File file = await File()
    return picker.pickImage(source: ImageSource.gallery, imageQuality: 35);
  }
}

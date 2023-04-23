import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/AsramaObject.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/Authentication.dart';
import '../Services/CustomPageRouteAnimation.dart';
import '../Services/StorageServices.dart';
import '../Widgets/UserSettings.dart';
import 'PengaturanAkun_Edit.dart';

class ProfilAsrama extends StatefulWidget {
  final CurrentUserObject currentUserObject;
  final AsramaObject asramaDetail;

  const ProfilAsrama(
      {Key? key, required this.currentUserObject, required this.asramaDetail})
      : super(key: key);

  @override
  State<ProfilAsrama> createState() => _ProfilAsramaState(
      currentUserObject: currentUserObject, asramaDetail: asramaDetail);
}

class _ProfilAsramaState extends State<ProfilAsrama> {
  final CurrentUserObject currentUserObject;
  AsramaObject asramaDetail;
  String? imagepath;

  _ProfilAsramaState(
      {required this.asramaDetail, required this.currentUserObject});

  Future<void> _signOut() async {}

  @override
  Widget build(BuildContext context) {
    imagepath = currentUserObject.fotoProfil;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Asrama'),
        leading: const BackButton(
          color: Colors.grey,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(flex: 1, child: Container()),
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
                                      backgroundImage:
                                          NetworkImage(imagepath!)),
                                ),
                              )
                            : const Center(
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
                                        const CircularProgressIndicator(),
                                        const SizedBox(width: 16),
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
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(4),
                              child: const CircleAvatar(
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
                  Expanded(flex: 1, child: Container()),
                ],
              ),
              const SizedBox(height: 20),
              UserSettings('Nama Asrama', widget.currentUserObject.namaLengkap!,
                  widget.currentUserObject.uid!, false, (String data) {
                setState(() {
                  widget.currentUserObject.namaLengkap = data;
                  Navigator.pop(context);
                  print(data);

                  FirebaseFirestore.instance
                      .collection('PengurusCollection')
                      .doc(widget.currentUserObject.uid)
                      .update({'namaLengkap': data});
                });
              }),
              UserSettings(
                  'Pengasuh',
                  widget.asramaDetail.pengasuh
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '')!,
                  widget.currentUserObject.uid!,
                  false, (String data) {
                Navigator.pop(context);
                setState(() {
                  widget.asramaDetail.pengasuh = data.split(',');
                  FirebaseFirestore.instance
                      .collection('AktivitasCollection')
                      .doc(widget.currentUserObject.kodeAsrama)
                      .update({'program': data.split(',')});
                });
              }),
              UserSettings(
                  'Program',
                  widget.asramaDetail.program
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '')!,
                  widget.currentUserObject.uid!,
                  false, (String data) {
                Navigator.pop(context);
                setState(() {
                  widget.asramaDetail.program = data.split(',');
                  FirebaseFirestore.instance
                      .collection('AktivitasCollection')
                      .doc(widget.currentUserObject.kodeAsrama)
                      .update({'Pengasuh': data.split(',')});
                });
              }),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(CustomPageRoute(
                      child: EditSetting(
                          'Profil Singkat',
                          widget.asramaDetail.profilSingkat,
                          widget.currentUserObject.uid!, (String data) {
                    Navigator.pop(context);
                    setState(() {
                      widget.asramaDetail.profilSingkat = data;
                      FirebaseFirestore.instance
                          .collection('AktivitasCollection')
                          .doc(widget.currentUserObject.kodeAsrama)
                          .update({'profilSingkat': data});
                    });
                  })));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Profil Singkat',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                              textAlign: TextAlign.start),
                          Container(
                            margin: const EdgeInsets.only(right: 0),
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.asramaDetail.profilSingkat,
                        style: GoogleFonts.poppins(color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

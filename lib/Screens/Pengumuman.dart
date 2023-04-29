import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/BottomSheets/PengumumanBaru.dart';
import 'package:esantren_insights_v1/Widgets/PengumumanWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pengumuman extends StatefulWidget {
  final CurrentUserObject userObject;
  const Pengumuman({Key? key, required this.userObject}) : super(key: key);

  @override
  State<Pengumuman> createState() => _PengumumanState(userObject);
}

class _PengumumanState extends State<Pengumuman> {
  final CurrentUserObject userObject;
  bool _isContainerCollapsed = false;
  bool _isImageAttached = false;
  bool _isButtonEnabled = true;
  String _judul = "";
  String _isi = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _PengumumanState(this.userObject);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isContainerCollapsed ? 0 : 100,
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: InkWell(
              onTap: () {
                //show modal bottomsheet on tap that return PengumumanBaru_BS
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TambahPengumuman_BS(
                          userObject: userObject,
                        ),
                      );
                    });
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                dashPattern: [5, 5],
                color: Colors.grey,
                strokeWidth: 1,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1, end: _isContainerCollapsed ? 0 : 1),
                    duration: Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 4),
                            Text('Buat Pengumuman Baru',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 14 * value)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
            child: Expanded(
                child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('AktivitasCollection')
              .doc(userObject.kodeAsrama)
              .collection('PengumumanLogs')
              .orderBy('timestamp', descending: true)
              .limit(10)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            print('length of pengumuman ${snapshot.data!.docs.length}');

            return NotificationListener(
              onNotification: (scrollNotification) {
                //if it's getting scrolled down then hide the container
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.scrollDelta! > 0) {
                  setState(() {
                    _isContainerCollapsed = true;
                  });
                }
                //if it scrolled to the very top, then show the container
                else if (scrollNotification is ScrollEndNotification &&
                    scrollNotification.metrics.pixels == 0) {
                  setState(() {
                    _isContainerCollapsed = false;
                  });
                }
                return true;
              },
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  print('apakah ada judul ${document['judul']}');
                  return PengumumanContainer(
                    userObject: userObject,
                    timestamp: document['timestamp'],
                    title: document['judul'],
                    content: document['isi'],
                    imageUrl: document['gambar'],
                    pdfUrl: document['file'],
                  );
                }).toList(),
              ),
            );
          },
        ))),
      ]),
    );
  }
}

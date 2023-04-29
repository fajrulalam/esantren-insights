import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/BottomSheets/DetailSantri_BS.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PengumumanContainer extends StatefulWidget {
  final String title;
  final String content;
  final Timestamp timestamp;
  final CurrentUserObject userObject;
  final String? imageUrl;
  final String? pdfUrl;

  PengumumanContainer(
      {required this.title,
      required this.content,
      this.imageUrl,
      this.pdfUrl,
      required this.timestamp,
      required this.userObject});

  @override
  _PengumumanContainerState createState() => _PengumumanContainerState();
}

class _PengumumanContainerState extends State<PengumumanContainer> {
  bool _expanded = false;

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _expanded ? Colors.grey[200] : Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Container(
              height: 40,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage(widget.userObject.fotoProfil!),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.userObject.namaLengkap!,
                        style: GoogleFonts.notoSans(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        //format this to EEE, dd MMM yyyy,
                        widget.timestamp.toDate().toString().substring(0, 16),
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ))
                ],
              )),
          Container(
            padding: EdgeInsets.only(left: 48.0, top: 8.0, right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title.toTitleCase(),
                  style: GoogleFonts.notoSans(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                if (widget.imageUrl != '')
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: '',
                        transitionDuration: Duration(milliseconds: 200),
                        pageBuilder: (context, animation1, animation2) {
                          return Center(
                            child: Stack(
                              children: [
                                InteractiveViewer(
                                  child: Image.network(
                                    widget.imageUrl!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      shape: CircleBorder(),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      height: 200.0,
                      child: Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _toggleExpand,
                  child: Text(
                    _expanded
                        ? widget.content
                        : widget.content.length < 200
                            ? widget.content
                            : widget.content.substring(0, 200) + '...',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.notoSans(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                if (_expanded && widget.pdfUrl != '')
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement download/open pdf
                    },
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text(widget.pdfUrl!),
                  ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}

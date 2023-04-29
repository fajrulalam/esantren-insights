import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Objects/PengumumanObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../Services/StorageServices.dart';

class TambahPengumuman_BS extends StatefulWidget {
  final CurrentUserObject userObject;
  const TambahPengumuman_BS({Key? key, required this.userObject})
      : super(key: key);
  @override
  _TambahPengumuman_BSState createState() => _TambahPengumuman_BSState();
}

class _TambahPengumuman_BSState extends State<TambahPengumuman_BS> {
  bool _isImageAttached = false;
  bool _isButtonEnabled = true;
  File _image = File('');
  String _judul = "";
  String _isi = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Buat Pengumuman Baru",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Icon(Icons.close)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Judul Pengumuman',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _judul = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul pengumuman harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    maxLines: 10,
                    minLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Isi Pengumuman',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isi = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi pengumuman harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Flexible(
                    child: TextButton(
                      onPressed: () async {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 75,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            _image = File(pickedFile.path);
                            _isImageAttached = true;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          if (!_isImageAttached) Icon(Icons.attach_file),
                          SizedBox(width: 8),
                          Text(_isImageAttached
                              ? "Gambar terlampir"
                              : "Lampirkan Gambar"),
                          //if image is attached, add a check icon
                          if (_isImageAttached)
                            Icon(Icons.check, color: Colors.green)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: _isImageAttached
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_isImageAttached && _image != null)
                    Center(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(
                            _image,
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: CircleBorder(),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isImageAttached = false;
                                  _image = File('');
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
                    ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          primary: Colors.blue,
                        ),
                        onPressed: () async {
                          //convert _image to XFile
                          XFile? xFile;
                          String imagePath = "";
                          if (_isImageAttached && _image != null) {
                            xFile = XFile(_image.path);
                            imagePath =
                                await StorageServices.uploadImagePengumuman(
                                    xFile!, widget.userObject);
                          }

                          //get values from the form
                          PengumumanObject pengumumanBaru = PengumumanObject(
                              judul: _judul,
                              isi: _isi,
                              timestamp: Timestamp.now(),
                              gambar: imagePath,
                              file: '');

                          //add the pengumauman baru class to the Firestore database AktivitasCollection/widget.userObject.kodeAsrama/PengumumanLogs
                          FirebaseFirestore.instance
                              .collection('AktivitasCollection')
                              .doc(widget.userObject.kodeAsrama)
                              .collection('PengumumanLogs')
                              .add(pengumumanBaru.toJson())
                              .then((value) => Navigator.pop(context, true));
                        },
                        child: Row(
                          children: [
                            Text(
                              "Buat Pengumuman",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.send_rounded),
                          ],
                        )),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

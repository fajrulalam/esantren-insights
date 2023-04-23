import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditSetting extends StatefulWidget {
  String setting;
  String current;
  String uid;
  final Function(String data) notifyParent;

  EditSetting(this.setting, this.current, this.uid, this.notifyParent);

  @override
  State<EditSetting> createState() => _EditSettingState(notifyParent);
}

class _EditSettingState extends State<EditSetting> {
  DateTime selectedDate = DateTime.now();
  String tglLahir = '';
  late TextEditingController controller;
  final Function(String data) notifyParent;

  _EditSettingState(this.notifyParent);

  @override
  void initState() {
    super.initState();
    tglLahir = widget.current;
    controller = TextEditingController(text: widget.current);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.setting),
        leading: const BackButton(
          color: Colors.grey,
        ),
      ),
      body: Center(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3))
            ]),
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
        child: Column(
          children: [
            widget.setting != 'Tanggal Lahir'
                ? Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 64, horizontal: 24),
                    child: SingleChildScrollView(
                      child: TextFormField(
                        maxLines: 7,
                        minLines: 1,
                        controller: controller,
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1))),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 64, horizontal: 24),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir',
                        border: const OutlineInputBorder(),
                        suffix: GestureDetector(
                          child: const Icon(
                            Icons.calendar_today,
                            size: 24,
                          ),
                          onTap: () {
                            print('tapped');
                            // controllerNama.text = 'lol';
                            showDatePicker(
                              locale: const Locale('id'),
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.blue,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((picked) {
                              if (picked != null && picked != selectedDate) {
                                final DateFormat formatter =
                                    DateFormat('dd-MM-yyyy');
                                final String formattedDate =
                                    formatter.format(picked);
                                setState(() {
                                  controller.text = formattedDate;
                                });
                                // controllerTglLahir.text = tglLahir;

                                // tglLahir = formattedDate;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    // updateData();
                    notifyParent(controller.text);
                  },
                  child: const Text('Simpan')),
            )
          ],
        ),
      )),
    );
  }

  void updateData() async {
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
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700))
            ],
          ),
        );
      },
    );
    FirebaseFirestore fs = FirebaseFirestore.instance;
    String fieldName = '';
    switch (widget.setting) {
      case 'Nama':
        fieldName = 'namaLengkap';
        break;
      case 'Panggilan':
        fieldName = 'namaPanggilan';
        break;
      case 'Kota Asal':
        fieldName = 'kotaAsal';
        break;
      case 'Tanggal Lahir':
        fieldName = 'tglLahir';
        break;
    }
    // await fs
    //     .collection('PengurusCollection')
    //     .doc(widget.uid)
    //     .update({fieldName: controller.text}).then((value) {
    //   // Navigator.pop(context);
    //   // Navigator.pop(context);
    //   // Navigator.pushAndRemoveUntil(
    //   //     context,
    //   //     MaterialPageRoute(
    //   //         builder: (BuildContext context) => HomePage('AccountSettings')),
    //   //     ModalRoute.withName(WidgetTree.id));
    // });
    // Navigator.pop(context);
  }
}

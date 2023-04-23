import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InvoiceBaru extends StatefulWidget {
  String setting;
  String current;
  CurrentUserObject currentUserObject;
  final Function(String data, int nominal) notifyParent;

  InvoiceBaru(
      this.setting, this.current, this.currentUserObject, this.notifyParent);

  @override
  State<InvoiceBaru> createState() => _InvoiceBaruState(notifyParent);
}

class _InvoiceBaruState extends State<InvoiceBaru> {
  DateTime selectedDate = DateTime.now();
  String tglLahir = '';
  late TextEditingController controllerBulan;
  late TextEditingController controllerNominal;
  final Function(String data, int nominal) notifyParent;
  List<String> listPreviousInvoice = [];

  _InvoiceBaruState(this.notifyParent);

  @override
  void initState() {
    super.initState();
    tglLahir = widget.current;
    String formattedDate = DateFormat('MMMM yyyy', 'id').format(DateTime.now());
    print(formattedDate);
    controllerBulan = TextEditingController(text: formattedDate);
    controllerNominal = TextEditingController(text: '0');
    getPreviousInvoice();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM yyyy', 'id').format(DateTime.now());
    final NumberFormat currencyFormat = NumberFormat('#,##0');

    print(formattedDate);

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bulan Tagihan',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                child: TextFormField(
                  readOnly: true,
                  maxLines: 2,
                  minLines: 1,
                  controller: controllerBulan,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1))),
                ),
              ),
              SizedBox(height: 24),
              Text('Nominal (Rp)',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                child: TextFormField(
                  maxLines: 2,
                  minLines: 1,
                  keyboardType: TextInputType.number,
                  controller: controllerNominal,
                  style: GoogleFonts.poppins(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.payments),
                    prefixText: 'Rp. ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1)),
                  ),
                  onChanged: (value) {
                    final numberValue = int.tryParse(value.replaceAll(',', ''));
                    if (numberValue != null) {
                      final formattedValue = currencyFormat
                          .format(numberValue)
                          .replaceAll(',', '.');
                      if (formattedValue != value) {
                        controllerNominal.value = TextEditingValue(
                          text: formattedValue,
                          selection: TextSelection.collapsed(
                              offset: formattedValue.length),
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                      onPressed: () {
                        bool invoiceAlreadyExist =
                            listPreviousInvoice.indexOf(controllerBulan.text) !=
                                -1;
                        if (invoiceAlreadyExist) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.deepOrangeAccent.withOpacity(1),
                              duration: Duration(milliseconds: 2000),
                              content: Text(
                                  'Invoice untuk bulan ${controllerBulan.text} sudah ada',
                                  style: GoogleFonts.poppins()),
                            ),
                          );
                          return;
                        }

                        FocusScope.of(context).unfocus();
                        // updateData();
                        notifyParent(
                            controllerBulan.text,
                            int.parse(
                                controllerNominal.text.replaceAll('.', '')));
                      },
                      child: const Text('Simpan')),
                ),
              )
            ],
          ),
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

  void getPreviousInvoice() {
    FirebaseFirestore.instance
        .collection("InvoiceCollection")
        .where('kodeAsrama', isEqualTo: widget.currentUserObject.kodeAsrama)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        listPreviousInvoice.add(element.id);
      });
    });
  }
}

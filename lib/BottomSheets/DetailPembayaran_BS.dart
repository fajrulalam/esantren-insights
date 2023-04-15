import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/PelunasanObject.dart';
import 'package:flutter/material.dart';
import 'package:esantren_insights_v1/Objects/SantriObject.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void detailPembayaranBottomSheet(BuildContext context,
    {required List<SantriObject> santriSudahLunas,
    required List<PelunasanObject> santriBelumLunas}) {
  //make a modal bottom sheet that has a tab bar with 2 tabs. one tab shows a list of santri that have paid, the other tab shows a list of santri that have not paid

  santriBelumLunas
      .sort((a, b) => b.jumlahTanggungan.compareTo(a.jumlahTanggungan));

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail Pembayaran",
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(
                              text: "Sudah Lunas",
                            ),
                            Tab(
                              text: "Belum Lunas",
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Column(
                                children: [
                                  //a row with title text and a button to close the bottom sheet
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: santriSudahLunas.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            santriSudahLunas[index].nama,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            "Lunas",
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green),
                                          ),
                                          // trailing: Text(DateFormat("dd MMMM yyyy").format(santriSudahLunas[index].tanggalPembayaran.toDate())),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: santriBelumLunas.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            santriBelumLunas[index].nama,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          trailing: //a text inside a red circular container
                                              Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(0.75),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${santriBelumLunas[index].daftarInvoiceBelumLunas.length}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${santriBelumLunas[index].daftarInvoiceBelumLunas.toString().replaceAll("[", "").replaceAll("]", "")}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.redAccent),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      });
}

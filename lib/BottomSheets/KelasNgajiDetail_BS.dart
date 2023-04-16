import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:esantren_insights_v1/Objects/SantriObject.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Objects/KelasNgajiObject.dart';

void detailKelasNgajiBottomSheet(BuildContext context,
    {required List<KelasNgajiObject> semuaKelasNgaji}) {
  //create a similar modal bottom sheet that i've made previously, but this time, it will show a list of all the classes
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
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24, bottom: 8, right: 8, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kelas Mengaji Hari Ini",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: semuaKelasNgaji.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          onTap: () {},
                          title: Text(
                            semuaKelasNgaji[index].kelasNgaji,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: semuaKelasNgaji[index].adaAbsensi
                              ? Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 12,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                          "${semuaKelasNgaji[index].timestamp.toDate().hour}:${semuaKelasNgaji[index].timestamp.toDate().minute}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green)),
                                    ],
                                  ),
                                )
                              : Text("belum dimulai",
                                  style: GoogleFonts.poppins(fontSize: 12)),
                          trailing: semuaKelasNgaji[index].adaAbsensi
                              ? RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${semuaKelasNgaji[index].hadir.length}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '/${semuaKelasNgaji[index].hadir.length + semuaKelasNgaji[index].sakit.length + semuaKelasNgaji[index].alfa.length + semuaKelasNgaji[index].izin.length}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  "Belum ada",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey),
                                )),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}

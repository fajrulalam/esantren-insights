import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:esantren_insights_v1/Objects/SantriObject.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void detailSantriBottomSheet(BuildContext context,
    {required String keterangan, required List<SantriObject> allSantri}) {
  List<SantriObject> filterSantriSesuaiKeterangan = [];
  String title = "";
  Color titleColor = Colors.black;

  switch (keterangan) {
    case "Ada":
      filterSantriSesuaiKeterangan = allSantri
          .where((element) => (element.statusKehadiran == "Ada" ||
              element.statusKehadiran == "Hadir"))
          .toList();
      title = "Santri yang Saat Ini di Asrama";
      titleColor = Colors.green;
      break;
    case "Izin":
      filterSantriSesuaiKeterangan = allSantri
          .where((element) =>
              element.statusKehadiran == "Izin" ||
              element.statusKehadiran == "Pulang")
          .toList();
      title = "Santri yang Saat Izin/Pulang";
      titleColor = Colors.orange;

      break;
    case "Sakit":
      filterSantriSesuaiKeterangan = allSantri
          .where((element) => element.statusKehadiran == "Sakit")
          .toList();
      title = "Santri yang Saat Ini Sakit";
      titleColor = Colors.red;
      break;
    default:
      title = "Semua Santri Aktif";
      filterSantriSesuaiKeterangan = allSantri;
      break;
  }

  filterSantriSesuaiKeterangan
      .sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));

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
                  Text(
                    "Santri $keterangan",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (keterangan == "Sakit")
              Expanded(
                child: ListView.builder(
                  itemCount: filterSantriSesuaiKeterangan.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        filterSantriSesuaiKeterangan[index].nama.toTitleCase(),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),

                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: filterSantriSesuaiKeterangan[index]
                                  .statusKesehatan['keluhan']
                                  .toString()
                                  .toCapitalized(),
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  '  (Dirawat di ${getDirawatDi(filterSantriSesuaiKeterangan[index].statusKesehatan)})',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // subtitle: Text(
                      //   'Dirawat di ${getDirawatDi(filterSantriSesuaiKeterangan[index].statusKesehatan)}',
                      //   style: GoogleFonts.poppins(fontSize: 12),
                      // ),
                    );
                  },
                ),
              )
            else if (keterangan == "Izin" || keterangan == "Pulang")
              Expanded(
                child: ListView.builder(
                  itemCount: filterSantriSesuaiKeterangan.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                          filterSantriSesuaiKeterangan[index]
                              .nama
                              .toTitleCase(),
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          'Izin hingga: ${getRencanaTanggalKembali(filterSantriSesuaiKeterangan[index].statusKepulangan)}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ));
                  },
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filterSantriSesuaiKeterangan.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                          filterSantriSesuaiKeterangan[index]
                              .nama
                              .toTitleCase(),
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          filterSantriSesuaiKeterangan[index].id,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ));
                  },
                ),
              )
          ],
        ),
      );
    },
  );
}

getRencanaTanggalKembali(Map<String, dynamic> map) {
  Timestamp rencanaTanggalKembali = map['rencanaTanggalKembali'];
  //format the timestamp to EEEE, dd MMMM yyyy
  DateTime dateTime = rencanaTanggalKembali.toDate();
  return DateFormat('EEEE, dd MMMM yyyy', 'id').format(dateTime);
}

String getDirawatDi(Map<String, dynamic> map) {
  return map['dirawatDi'];
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

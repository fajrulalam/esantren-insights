import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:esantren_insights_v1/Classes/CekAbsensiClass.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Objects/KelasNgajiObject.dart';

class CekAbsensi2_Kelas extends StatefulWidget {
  static String id = 'cekabsensi2_kelas';
  final String kelas;
  final CurrentUserObject userObject;
  const CekAbsensi2_Kelas(
      {Key? key, required this.kelas, required this.userObject})
      : super(key: key);

  @override
  State<CekAbsensi2_Kelas> createState() => _CekAbsensi2_KelasState();
}

class _CekAbsensi2_KelasState extends State<CekAbsensi2_Kelas> {
  List<KelasNgajiObject> kelasNgajiList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.kelas);
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi Kelas VII A'),
        leading: BackButton(
          color: Colors.grey,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: kelasNgajiList.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                        child: InkWell(
                      onTap: () {
                        //show modal bottom sheet here
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return DetailAbsen_BS(
                                kelasNgajiList: kelasNgajiList,
                                selectedIndex: index,
                              );
                            });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 16),
                            child: Row(
                              children: [
                                Text(
                                  formatTanggalMulai(
                                      kelasNgajiList[index].timestamp),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${kelasNgajiList[index].hadir.length}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '/${kelasNgajiList[index].hadir.length + kelasNgajiList[index].sakit.length + kelasNgajiList[index].izin.length + kelasNgajiList[index].alfa.length}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        size: 12, color: Colors.grey),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      kelasNgajiList[index].pengabsen,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timelapse_outlined,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      convertSecondsToMinutes(
                                          kelasNgajiList[index]
                                              .totalDurationInSeconds),
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void getData() async {
    kelasNgajiList = await CekAbsensiClass.getKelasNgajiList(
        widget.userObject, widget.kelas);
    setState(() {});
  }

  String convertSecondsToMinutes(num? totalDurationInSeconds) {
    //convert seconds to minutes
    int minutes = (totalDurationInSeconds! / 60).truncate();
    // return in the format of m minutes
    return '${minutes} menit';
  }

  String formatTanggalMulai(Timestamp timestamp) {
    //format to EEEE, dd MMM yyyy in id locale
    var formatter = new DateFormat('EEEE, dd MMM yyyy', 'id');
    String formatted = formatter.format(timestamp.toDate());
    return formatted;
  }
}

class DetailAbsen_BS extends StatefulWidget {
  final List<KelasNgajiObject> kelasNgajiList;
  final int selectedIndex;
  const DetailAbsen_BS(
      {Key? key, required this.kelasNgajiList, required this.selectedIndex})
      : super(key: key);

  @override
  State<DetailAbsen_BS> createState() =>
      _DetailAbsen_BSState(kelasNgajiList, selectedIndex);
}

class _DetailAbsen_BSState extends State<DetailAbsen_BS> {
  List<KelasNgajiObject> kelasNgajiList;
  int selectedIndex;

  _DetailAbsen_BSState(this.kelasNgajiList, this.selectedIndex);

  late int index = selectedIndex;
  List<dynamic> absen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> hadirList = [];
    List<dynamic> sakitList = [];
    List<dynamic> alfaList = [];
    List<dynamic> izinList = [];
    kelasNgajiList[index].hadir.forEach((element) {
      hadirList.add(element + ', Hadir');
    });
    kelasNgajiList[index].hadir = hadirList;

    kelasNgajiList[index].sakit.forEach((element) {
      sakitList.add(element + ', Sakit');
    });
    kelasNgajiList[index].sakit = sakitList;

    kelasNgajiList[index].alfa.forEach((element) {
      alfaList.add(element + ', Alfa');
    });
    kelasNgajiList[index].alfa = alfaList;

    kelasNgajiList[index].izin.forEach((element) {
      izinList.add(element + ', Izin');
    });
    kelasNgajiList[index].izin = izinList;

    absen = kelasNgajiList[index].hadir +
        kelasNgajiList[index].sakit +
        kelasNgajiList[index].alfa;
    kelasNgajiList[index].izin;
    //sort the absenlist in alphabeticalorder
    absen.sort((a, b) => a.toString().compareTo(b.toString()));

    return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //title text
              Container(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (index > 0) {
                            setState(() {
                              index--;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_left,
                          color: Colors.grey,
                          size: 24,
                        )),
                    Center(
                      child: Text(
                        formatTanggalMulai(kelasNgajiList[index].timestamp),
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (index < kelasNgajiList.length - 1) {
                            setState(() {
                              index++;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_right,
                          color: Colors.grey,
                          size: 24,
                        )),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                child: kelasNgajiList[index].imagePath == 'tidak ada foto'
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        dashPattern: [8, 4],
                        strokeWidth: 2,
                        color: Colors.grey,
                        child: Container(
                          height: 200,
                          child: Center(
                            child: Text(
                              'Tidak ada foto absen',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    : Image.network(
                        kelasNgajiList[index].imagePath,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    // padding: EdgeInsets.only(right: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hadir',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green),
                        ),
                        SizedBox(height: 4),
                        Text(
                          kelasNgajiList[index].hadir.length.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.only(right: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sakit/Izin',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${kelasNgajiList[index].sakit.length + kelasNgajiList[index].izin.length}',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.only(right: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Alfa',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent),
                        ),
                        SizedBox(height: 4),
                        Text(
                          kelasNgajiList[index].alfa.length.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       bottom: 8.0, left: 16),
              //   child: Row(
              //     children: [
              //       Text('Daftar Hadir',
              //           textAlign: TextAlign.left,
              //           style: GoogleFonts.notoSans(
              //               fontSize: 16,
              //               fontWeight: FontWeight.w600,
              //               color: Colors.black)),
              //     ],
              //   ),
              // ),
              DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                child: Container(
                  height: 30 * absen.length.toDouble(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: absen.length,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        //add a border bottom
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.5)))),
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                (index + 1).toString(),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 8,
                              child: Text(
                                absen[index].split(',')[1],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: Text(
                                absen[index].split(',')[2].trim(),
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: absen[index].split(',')[2].trim() ==
                                            'Hadir'
                                        ? Colors.green
                                        : Colors.deepOrangeAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String formatTanggalMulai(Timestamp timestamp) {
    //format to EEEE, dd MMM yyyy in id locale
    var formatter = new DateFormat('EEEE, dd MMM yyyy', 'id');
    String formatted = formatter.format(timestamp.toDate());
    return formatted;
  }
}
